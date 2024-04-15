import Foundation

/// Abstract configuration protocol for Search Engine
public protocol AbstractSearchEngineConfiguration {
    /// Location provider for SearchEngine
    var locationProvider: LocationProvider? { get set }

    /// default configuration
    static var `default`: Self { get }
}

/// Common root for `SearchEngine` and `CategorySearchEngine`.
/// Should never be instantiated directly
public class AbstractSearchEngine: FeedbackManagerDelegate {
    var dataLayerProviders: [IndexableDataProvider] = []
    var dataResolvers: [IndexableDataResolver] { dataLayerProviders }

    let engineApi: CoreSearchEngine.ApiType
    let engine: CoreSearchEngineProtocol

    var locationProviderWrapper: WrapperLocationProvider?

    /// SearchEngine supports the latest Single-Box Search APIs
    public let supportSBS: Bool

    /// Location provider for search results `proximity` argument
    public let locationProvider: LocationProvider?

    /// Manager to provide feedback events
    public let feedbackManager: FeedbackManager

    /// `OfflineManager` with `default` TileStore.
    public private(set) var offlineManager: SearchOfflineManager

    // Manager to send raw events to Mapbox Telemetry
    let eventsManager: EventsManager

    // Reporter for tracking user activity
    let userActivityReporter: CoreUserActivityReporter

    /// Default options to use when `nil` was passed to the `search(…: options:)` call
    ///
    /// Full `SearchOptions` structure would be used when nothing was passed to the `search` function
    /// In other case, each structure field would be tested. Each `nil` field in `search(options:)` parameter
    /// would be replaced with the value from `defaultSearchOptions`
    public var defaultSearchOptions: SearchOptions

    let internalProvidersBasePriority = 100

    /// Basic internal initializer
    /// - Parameters:
    ///   - accessToken: Mapbox Access Token to be used. Info.plist value for key `MGLMapboxAccessToken` will be used
    /// for `nil` argument
    ///   - locationProvider: Provider configuration of LocationProvider that would grant location data by default
    ///   - serviceProvider: Internal `ServiceProvider` for sharing common dependencies like favoritesService or
    /// eventsManager
    ///   - supportSBS: enable support the latest Single-Box Search APIs
    init(
        accessToken: String? = nil,
        serviceProvider: ServiceProviderProtocol & EngineProviderProtocol,
        locationProvider: LocationProvider? = DefaultLocationProvider(),
        defaultSearchOptions: SearchOptions = SearchOptions(),
        supportSBS: Bool = true
    ) {
        guard let accessToken = accessToken ?? serviceProvider.getStoredAccessToken() else {
            fatalError(
                "No access token was found. Please, provide it in init(accessToken:) or in Info.plist at '\(accessTokenPlistKey)' key"
            )
        }

        self.supportSBS = supportSBS
        self.locationProvider = locationProvider
        self.locationProviderWrapper = WrapperLocationProvider(wrapping: locationProvider)
        self.eventsManager = serviceProvider.eventsManager
        self.feedbackManager = serviceProvider.feedbackManager
        self.defaultSearchOptions = defaultSearchOptions
        self.engineApi = supportSBS ? .SBS : .geocoding

        self.userActivityReporter = .getOrCreate(
            for: .init(
                accessToken: accessToken,
                userAgent: defaultUserAgent,
                eventsUrl: nil
            )
        )

        self.engine = serviceProvider.createEngine(
            apiType: engineApi,
            accessToken: accessToken,
            locationProvider: locationProviderWrapper
        )
        self.offlineManager = SearchOfflineManager(engine: engine, tileStore: SearchTileStore(accessToken: accessToken))

        feedbackManager.delegate = self
        _Logger.searchSDK.info("Init \(self) for API v.\(engineApi)")

        for (index, provider) in serviceProvider.dataLayerProviders.enumerated() {
            do {
                let interactor = try register(dataProvider: provider, priority: internalProvidersBasePriority + index)
                provider.registerProviderInteractor(interactor: interactor)
            } catch {
                _Logger.searchSDK.error("Failed to call \(#function) due to error: \(error)")
                eventsManager.reportError(error)
            }
        }
    }

    /// Initializer with safe-to-go defaults
    /// - Parameters:
    ///   - accessToken: Mapbox Access Token to be used. Info.plist value for key `MGLMapboxAccessToken` will be used
    /// for `nil` argument
    ///   - locationProvider: Provider configuration of LocationProvider that would grant location data by default
    ///   - defaultSearchOptions: Default options to use when `nil` was passed to the `search(…: options:)` call
    ///   - supportSBS: enable support the latest Single-Box Search APIs
    public convenience init(
        accessToken: String? = nil,
        locationProvider: LocationProvider? = DefaultLocationProvider(),
        defaultSearchOptions: SearchOptions = SearchOptions(),
        supportSBS: Bool = true
    ) {
        self.init(
            accessToken: accessToken,
            serviceProvider: ServiceProvider.shared,
            locationProvider: locationProvider,
            defaultSearchOptions: defaultSearchOptions,
            supportSBS: supportSBS
        )
    }

    /// Register indexable data provider to provide custom data layer for SearchEngine
    /// - Parameters:
    ///   - dataProvider: IndexableDataProvider to register
    ///   - priority: data layer priority compared with other layers. Bigger is higher in result's list.
    /// - Returns: interactor for data operations (add, update, delete)
    /// - Throws: `SearchError.failedToRegisterDataProvider(error, dataProvider)`
    public func register(dataProvider: IndexableDataProvider, priority: Int) throws -> RecordsProviderInteractor {
        let providerIdentifier = type(of: dataProvider).providerIdentifier
        let coreRecordsLayer = engine.createUserLayer(providerIdentifier, priority: Int32(priority))

        engine.addUserLayer(coreRecordsLayer)
        dataLayerProviders.append(dataProvider)

        return RecordsProviderInteractorNativeCore(
            userRecordsLayer: coreRecordsLayer,
            registeredIdentifier: providerIdentifier
        )
    }

    func resolve(
        suggestion: SearchResultSuggestion,
        completionQueue: DispatchQueue = .main,
        completion: @escaping (Result<SearchResult, SearchError>) -> Void
    ) {
        guard let resolver = dataResolver(for: suggestion.dataLayerIdentifier) else {
            assertionFailure("No corresponding provider was found for identifier \(suggestion.dataLayerIdentifier)")
            completion(.failure(.dataResolverNotFound(suggestion)))
            return
        }

        resolver.resolve(suggestion: suggestion) { resolvedResult in
            completionQueue.async {
                if let resolvedResult {
                    completion(.success(resolvedResult))
                } else {
                    _Logger.searchSDK.info("Failed to resolve result \(suggestion) in resolver \(resolver)")
                    completion(.failure(.resultResolutionFailed(suggestion)))
                }
            }
        }
    }

    func resolve(
        suggestions: [SearchResultSuggestion],
        completionQueue: DispatchQueue = .main,
        completion: @escaping ([SearchResult]) -> Void
    ) {
        let resolvedResultsQueue = DispatchQueue(label: "com.mapbox.search.category.resolvedResults")
        let resolutionDispatchGroup = DispatchGroup()

        /// Accumulate searchResults in this collection to follow the origin order
        var resultsBuffer: [SearchResult?] = Array(repeating: nil, count: suggestions.count)

        func addResolvedResultAndLeaveGroup(_ result: SearchResult, at index: Int) {
            resolvedResultsQueue.async {
                resultsBuffer[index] = result
                resolutionDispatchGroup.leave()
            }
        }

        /// `ServerSearchResult` implements `SearchResult` protocol as well as `SearchResultSuggestion`
        /// However, we still may get in response a favorite or history record
        /// This records can be checked by `dataLayerIdentifier` field
        /// Try to resolve the result first. Otherwise, add directly to the array
        /// Pay an attention that `resolve` method is async
        /// So multithreading sync is required
        for (index, suggestion) in suggestions.enumerated() {
            if let resolver = dataResolver(for: suggestion.dataLayerIdentifier) {
                resolutionDispatchGroup.enter()
                resolver.resolve(suggestion: suggestion) { resolvedResult in
                    guard let resolvedResult else { return }

                    addResolvedResultAndLeaveGroup(resolvedResult, at: index)
                }
            } else if let resolvedResult = suggestion as? SearchResult {
                resolutionDispatchGroup.enter()

                addResolvedResultAndLeaveGroup(resolvedResult, at: index)
            } else {
                assertionFailure("Unsupported configuration: Every search result must contain dataProvider information")
            }
        }

        resolutionDispatchGroup.notify(qos: .userInitiated, queue: .main) {
            completionQueue.async {
                assert(suggestions.count == resultsBuffer.count)

                let resolvedResults = resultsBuffer.compactMap { $0 }
                assert(resultsBuffer.count == resolvedResults.count)

                completion(resolvedResults)
            }
        }
    }

    func dataResolver(for providerIdentifier: String) -> IndexableDataResolver? {
        dataResolvers.first(where: { type(of: $0).providerIdentifier == providerIdentifier })
    }
}
