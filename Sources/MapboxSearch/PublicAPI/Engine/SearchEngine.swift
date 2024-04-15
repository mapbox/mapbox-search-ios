import Foundation
import MapKit

/// Declares the list of methods for receiving result of search and resolve operations
public protocol SearchEngineDelegate: AnyObject {
    /// Search Engine calls this method for every search update
    /// - Parameter searchEngine: engine which has updated results
    /// - Parameter searchEngine: calling engine
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine)

    /// Search Engine calls this method for every offline search update
    /// - Parameter results: resolved search results
    /// - Parameter suggestions: suggestions for search results
    /// - Parameter searchEngine: calling engine
    func offlineResultsUpdated(_ results: [SearchResult], suggestions: [SearchSuggestion], searchEngine: SearchEngine)

    /// Search Engine did resolve SearchSuggestion.
    /// To receive resolved Search result you have to call "select(suggestion: SearchSuggestion)" method
    /// - Parameter result: resolved search result
    /// - Parameter searchEngine: calling engine
    func resultResolved(result: SearchResult, searchEngine: SearchEngine)

    /// _Optional._
    /// Search Engine did resolve SearchSuggestion's.
    /// - Parameter results: resolved search result
    /// - Parameter searchEngine: calling engine
    func resultsResolved(results: [SearchResult], searchEngine: SearchEngine)

    /// Report search error during engine interaction
    /// - Parameter searchError: search error
    /// - Parameter searchEngine: calling engine
    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine)
}

extension SearchEngineDelegate {
    /// Default implementation does nothing
    /// - Parameters:
    ///   - results: resolved search result
    ///   - searchEngine: calling engine
    public func resultsResolved(results: [SearchResult], searchEngine: SearchEngine) {}

    /// Default implementation does nothing
    /// - Parameter results: resolved search results
    /// - Parameter suggestions: suggestions for search results
    /// - Parameter searchEngine: calling engine
    public func offlineResultsUpdated(
        _ results: [SearchResult],
        suggestions: [SearchSuggestion],
        searchEngine: SearchEngine
    ) {}
}

/**
 An entry object for online search with autocomplete suggestions powered by Mapbox Search services

 SearchEngine requires [Mapbox Access Token](https://account.mapbox.com/access-tokens/) with any scope and visibility.
 We recommend to pass your token through  `MBXAccessToken` key in application's `Info.plist` to share the token with the Mapbox SDKs. You may choose to provide the accessToken as a parameter value instead.

 You must always assign `delegate` to receive search results provided by the engine.
 Update the `SearchEngine.query` value to start or continue your search experience.
 It is possible to update `query` value in real-time as the user types because the actual requests have a debounce logic.

 __Listing 1__ Create you first search request

     let engine = SearchEngine()
     engine.delegate = self
     engine.query = "Mapbox"

 Implement `SearchEngineDelegate` protocol to receive updates and search results with coordinates data. Pay attention that SearchEngine provides a list of `SearchSuggestion` which doesn't include coordinates information.

 __Listing 2__ Implement `SearchEngineDelegate` protocol

        extension ViewController: SearchEngineDelegate {
            func resultsUpdated(searchEngine: SearchEngine) {
                displaySearchResults(searchEngine)
            }

            func resolvedResult(result: SearchResult) {
                presentSelectedResult(result)
            }

            func searchErrorHappened(searchError: SearchError) {
                presentSearchError(searchError)
            }
        }

 # Retrieve coordinates
 Call `select(suggestion: SearchSuggestion)` when a customer makes a choice from the search results list to receive a `SearchResult` with populated coordinates field.
 You can expect a resolved search result with populated coordinates to be returned in `SearchEngineDelegate.resolvedResult(result: SearchResult)` delegate method.

 __Listing 3__ Select search result

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let suggestion = searchSuggestions[indexPath.row]

            dataSource.select(suggestion: suggestion)
        }

        …
        // SearchEngineDelegate implementation
        func resolvedResult(result: SearchResult) {
            presentAnnotationAt(coordinate: result.coordinate,
                                     title: result.name,
                                  subtitle: result.address?.formattedAddress(style: .medium))
        }

 - Note: SearchEngine may respond with category suggestion. Selecting such suggestion would produce a new set of search results.

 # Location bias
 Location is strongly recommended for accurate search results. By default, `SearchEngine` would anticipate `DefaultLocationProvider` to fulfill location data.
 `DefaultLocationProvider` would receive location updates if application already have a location permission. The default implementation declare low accuracy
 for better battery efficiency.
 It's possible to provide exact coordinate for search request with `search(query:options:)` function.
 Engine will reuse these coordinates on each search request. To reset to default LocationProvider behavior,
 call `search(query:options:)` with nil proximity in `SearchRequest`.

 __Listing 4__ Provide search coordinate

        let engine = SearchEngine()
        engine.search(query: "mapbox", options: SearchOptions(proximity: CLLocationCoordinate2D(latitude: 38.8998315, longitude: -77.0346164)))

 */
public class SearchEngine: AbstractSearchEngine {
    /// Offline mode types
    public enum OfflineMode {
        /// Offline mode enabled
        case enabled

        /// Offline mode disabled
        case disabled
    }

    /// Offline mode state for engine
    public private(set) var offlineMode: OfflineMode = .disabled

    /// Set new offline mode. Enabling may take some to SearchEngine to detect all reagins in current TileStore
    ///
    /// - Parameters:
    ///   - mode: offline mode Enable/Disable
    ///   - completion: called once `SearchEngine` ready for offline search
    public func setOfflineMode(_ mode: OfflineMode, completion: (() -> Void)?) {
        switch mode {
        case .enabled:
            offlineManager.registerCurrentTileStore { [weak self] in
                self?.offlineMode = mode
                completion?()
            }
        case .disabled:
            offlineMode = mode
            completion?()
        }
    }

    /// Delegate is required for SearchEngine interaction
    public weak var delegate: SearchEngineDelegate?

    /// Current search suggestions results.
    public private(set) var suggestions: [SearchSuggestion] = []

    /// Search response information for current search items.
    /// Can be used for submitting `missing result` feedback
    public private(set) var responseInfo: SearchResponseInfo?

    private enum Query: ExpressibleByStringLiteral {
        case string(String)
        case category(String)

        var stringQuery: String? {
            switch self {
            case .string(let query):
                return query
            case .category:
                return nil
            }
        }

        init(stringLiteral value: StringLiteralType) {
            self = .string(value)
        }
    }

    private var queryValue: Query = ""

    /// Actual search query. New value starts new search request in short amount of time.
    /// New search will reuse latest requestOptions
    public var query: String {
        get {
            queryValue.stringQuery ?? ""
        }
        set {
            queryValue = .string(newValue)
            startSearch()
        }
    }

    override var dataResolvers: [IndexableDataResolver] { super.dataResolvers + [self] }

    var engineSearchFunction: (String, [String], CoreSearchOptions, @escaping (CoreSearchResponseProtocol?) -> Void)
        -> Void
    {
        offlineMode == .disabled ? engine.search : engine.searchOffline
    }

    var engineReverseGeocodingFunction: (CoreReverseGeoOptions, @escaping (CoreSearchResponseProtocol?) -> Void)
        -> Void
    {
        offlineMode == .disabled ? engine.reverseGeocoding : engine.reverseGeocodingOffline
    }

    func retrieve(suggestion: SearchSuggestion) {
        guard let responseProvider = suggestion as? CoreResponseProvider else {
            assertionFailure()
            return
        }

        assert(offlineMode == .disabled)

        engine.nextSearch(
            for: responseProvider.originalResponse.coreResult,
            with: responseProvider.originalResponse.requestOptions
        ) { [weak self] serverResponse in
            self?.processResponse(serverResponse, suggestion: suggestion)
        }
    }

    private func startSearch(options: SearchOptions? = nil) {
        guard let queryValueString = queryValue.stringQuery else {
            assertionFailure()
            return
        }

        let options = options?.merged(defaultSearchOptions) ?? defaultSearchOptions

        engineSearchFunction(queryValueString, [], options.toCore(apiType: engineApi)) { [weak self] response in
            self?.processResponse(response, suggestion: nil)
        }
    }

    private func processBatchResponse(_ coreResponse: CoreSearchResponseProtocol?) {
        guard let coreResponse else {
            eventsManager.reportError(.responseProcessingFailed)
            delegate?.searchErrorHappened(searchError: .responseProcessingFailed, searchEngine: self)
            assertionFailure("Response should never be nil")
            return
        }

        let response = SearchResponse(coreResponse: coreResponse)
        switch response.process() {
        case .success(let result):
            delegate?.resultsResolved(results: result.results, searchEngine: self)
        case .failure(let searchError):
            eventsManager.reportError(searchError)
            delegate?.searchErrorHappened(searchError: searchError, searchEngine: self)
        }
    }

    private func preProcessResponse(_ coreResponse: CoreSearchResponseProtocol?) -> SearchResponse? {
        assert(Thread.isMainThread)

        guard let coreResponse else {
            assertionFailure("Response should never be nil")
            eventsManager.reportError(.responseProcessingFailed)
            delegate?.searchErrorHappened(searchError: .responseProcessingFailed, searchEngine: self)
            return nil
        }

        switch queryValue {
        case .string(let query):
            if coreResponse.request.query != query {
                return nil
            }
        case .category:
            // CoreSDK currently doesn't support arguments for category suggestions
            if !coreResponse.request.query.isEmpty {
                return nil
            }
        }

        return SearchResponse(coreResponse: coreResponse)
    }

    private func preProcessRetrieveResponse(_ coreResponse: CoreSearchResponseProtocol?) -> SearchResponse? {
        assert(Thread.isMainThread)

        guard let coreResponse else {
            assertionFailure("Response should never be nil")
            eventsManager.reportError(.responseProcessingFailed)
            delegate?.searchErrorHappened(searchError: .responseProcessingFailed, searchEngine: self)

            return nil
        }

        return SearchResponse(coreResponse: coreResponse)
    }

    /// Process core search response and update delegate.
    /// - Parameters:
    ///   - coreResponse: coreResponse to process
    ///   - suggestion: original suggestion
    private func processResponse(_ coreResponse: CoreSearchResponseProtocol?, suggestion: SearchSuggestion?) {
        guard let response = preProcessResponse(coreResponse) else {
            return
        }

        switch response.process() {
        case .success(let responseResult):
            responseInfo = SearchResponseInfo(response: response.coreResponse, suggestion: suggestion)
            suggestions = responseResult.suggestions

            if offlineMode == .enabled {
                delegate?.offlineResultsUpdated(
                    responseResult.results,
                    suggestions: responseResult.suggestions,
                    searchEngine: self
                )
            } else {
                delegate?.suggestionsUpdated(suggestions: suggestions, searchEngine: self)
            }

        case .failure(let searchError):
            eventsManager.reportError(searchError)
            delegate?.searchErrorHappened(searchError: searchError, searchEngine: self)
        }
    }

    private func resolveServerRetrieveResponse(_ coreResponse: CoreSearchResponseProtocol?) -> SearchResult? {
        guard let response = preProcessRetrieveResponse(coreResponse) else {
            return nil
        }

        switch response.process() {
        case .success(let responseResult):
            return responseResult.results.first

        case .failure:
            return nil
        }
    }

    private func resolveServerResponse(coreResponse: CoreSearchResponseProtocol?) -> SearchResult? {
        guard let response = preProcessResponse(coreResponse) else {
            return nil
        }
        switch response.process() {
        case .success(let responseResult):
            return responseResult.results.first
        case .failure:
            return nil
        }
    }
}

// MARK: - Public API

extension SearchEngine {
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - query: query string to search
    ///   - options: if no value provided Search Engine will use options from requestOptions field
    public func search(query: String, options: SearchOptions? = nil) {
        precondition(delegate != nil, "Assign delegate to use \(SearchEngine.self) search functionality")

        if offlineMode == .enabled {
            userActivityReporter.reportActivity(forComponent: "offline-search-engine-forward-geocoding")
        } else {
            userActivityReporter.reportActivity(forComponent: "search-engine-forward-geocoding-suggestions")
        }

        queryValue = .string(query)

        startSearch(options: options)
    }

    /// Select one of the provided `SearchSuggestion`'s.
    /// Search flow would continue if category suggestion was selected.
    /// - Parameter suggestion: Suggestion to continue the search and retrieve resolved `SearchResult` via delegate.
    public func select(suggestion: SearchSuggestion) {
        userActivityReporter.reportActivity(forComponent: "search-engine-forward-geocoding-selection")

        // Call `onSelected` for only supported types
        // but avoid it for category suggestions (like Cafe category)
        if let responseProvider = suggestion as? CoreResponseProvider, !(suggestion is SearchCategorySuggestion) {
            engine.onSelected(
                forRequest: responseProvider.originalResponse.requestOptions,
                result: responseProvider.originalResponse.coreResult
            )
        }

        switch suggestion {
        case let categorySuggestion as SearchCategorySuggestion:
            retrieve(suggestion: categorySuggestion)
        case let querySuggestion as SearchQuerySuggestion:
            retrieve(suggestion: querySuggestion)
        case let resultSuggestion as SearchResultSuggestion:
            resolve(suggestion: resultSuggestion) { [weak self] (result: Result<SearchResult, SearchError>) in
                guard let self else {
                    assertionFailure("Owning object was deallocated")
                    return
                }

                switch result {
                case .success(let resolvedResult):
                    self.delegate?.resultResolved(result: resolvedResult, searchEngine: self)
                case .failure(let searchError):
                    self.eventsManager.reportError(searchError)
                    self.delegate?.searchErrorHappened(searchError: searchError, searchEngine: self)
                }
            }
        default:
            assertionFailure("Unsupported configuration")
        }
    }

    /// Function to select multiple suggestions at once.
    /// With the current implementation, only POI suggestions support batch resolving.
    /// All suggestions must originate from the same search request.
    /// Suggestions with other types will be ignored. You can use `SearchSuggestion.batchResolveSupported` field for
    /// filtering.
    /// - Parameter suggestions: suggestions list to resolve. All suggestions must originate from the same search
    /// request.
    public func select(suggestions: [SearchSuggestion]) {
        for suggestion in suggestions {
            let supported = (suggestion as? CoreResponseProvider)?.originalResponse.coreResult.action?
                .isMultiRetrievable == true
            if !supported {
                _Logger.searchSDK
                    .warning("Unsupported suggestion: \(suggestion.name) of type: \(suggestion.suggestionType)")
            }
        }
        let suggestionsImpls = suggestions
            .compactMap { $0 as? CoreResponseProvider }
            .filter { $0.originalResponse.coreResult.action?.isMultiRetrievable == true }

        guard suggestionsImpls.isEmpty == false else {
            return
        }
        let options = suggestionsImpls[0].originalResponse.requestOptions
        let coreSearchResults = suggestionsImpls.map(\.originalResponse.coreResult)

        engine.batchResolve(results: coreSearchResults, with: options) { response in
            self.processBatchResponse(response)
        }
    }

    /// Reverse geocoding of coordinates to addresses.
    /// The default behavior in reverse geocoding is to return at most one feature at each of the multiple levels of the
    /// administrative hierarchy (for example, one address, one region, one country).
    /// Increasing the limit allows returning multiple features of the same type, but only for one type (for example,
    /// multiple address results).
    /// Consequently, setting limit to a higher-than-default value requires specifying exactly one types parameter.
    /// - Parameters:
    ///   - options: Options with coordinates, mode, limits and query types for reverse geocoding.
    ///   - completion: completion handler with either reverse geocoding Resuts or Error.
    public func reverseGeocoding(
        options: ReverseGeocodingOptions,
        completion: @escaping (Result<[SearchResult], SearchError>) -> Void
    ) {
        assert(Thread.isMainThread)

        if offlineMode == .enabled {
            userActivityReporter.reportActivity(forComponent: "offline-search-engine-reverse-geocoding")
        } else {
            userActivityReporter.reportActivity(forComponent: "search-engine-reverse-geocoding")
        }

        engineReverseGeocodingFunction(options.toCore()) { [weak self] response in
            guard let self else {
                assertionFailure("Owning object was deallocated")
                return
            }

            guard let response else {
                self.eventsManager.reportError(.responseProcessingFailed)
                completion(.failure(.responseProcessingFailed))
                assertionFailure("Response should never be nil")
                return
            }

            switch response.result {
            case .success(let results):
                completion(
                    .success(
                        results.compactMap { ServerSearchResult(coreResult: $0, response: response) }
                    )
                )

            case .failure(let responseError):
                let wrappedError = SearchError.reverseGeocodingFailed(
                    reason: responseError,
                    options: options
                )

                completion(.failure(wrappedError))
            }
        }
    }
}

// MARK: - IndexableDataResolver

extension SearchEngine: IndexableDataResolver {
    /// Static identifier of Mapbox Server results
    public static var providerIdentifier: String { "MapboxServerAPIDataProvider" }

    /// Resolves ``SearchResultSuggestion`` into ``SearchResult`` through Mapbox API.
    /// Should never be called directly.
    ///
    /// - Parameters:
    ///   - suggestion: suggestion to resolve
    ///   - completion: completion closure
    public func resolve(suggestion: SearchResultSuggestion, completion: @escaping (SearchResult?) -> Void) {
        assert(suggestion.dataLayerIdentifier == Self.providerIdentifier)

        switch suggestion {
        case let suggestion as SearchResultSuggestionImpl:
            engine.nextSearch(
                for: suggestion.originalResponse.coreResult,
                with: suggestion.originalResponse.requestOptions
            ) { coreSearchResponse in
                // Processing search response for Suggestion with type Query may return multiple suggestions or results.
                // For other types we are expecting single result.
                let searchResult = self.resolveServerRetrieveResponse(coreSearchResponse)
                completion(searchResult)
            }
        case let suggestion as SearchResult:
            completion(suggestion)

        default:
            assertionFailure(
                "Class `\(type(of: suggestion))` must confirm `\(SearchResult.self)` protocol in current SDK implementation"
            )
            // TODO: Should pass error here to IndexableDataResolver.
            // Breaking changes required. https://github.com/mapbox/mapbox-search-ios/issues/309
            completion(nil)
        }
    }
}
