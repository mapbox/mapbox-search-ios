import Foundation

let accessTokenPlistKey = "MBXAccessToken"
let baseURLPlistKey = "MapboxAPIBaseURL"

protocol ServiceProviderProtocol {
    var localFavoritesProvider: FavoritesProvider { get }
    var localHistoryProvider: HistoryProvider { get }
    var eventsManager: EventsManager { get }
    var feedbackManager: FeedbackManager { get }
    var dataLayerProviders: [IndexableDataProvider] { get }
}

protocol EngineProviderProtocol {
    func createEngine(
        apiType: CoreSearchEngine.ApiType,
        accessToken: String,
        locationProvider: CoreLocationProvider?
    ) -> CoreSearchEngineProtocol

    func getStoredAccessToken() -> String?
}

/// Built-in local data provider for ``FavoriteRecord`` data.
public typealias FavoritesProvider = LocalDataProvider<FavoriteRecord>

/// Built-in local data provider for ``HistoryRecord`` data.
public typealias HistoryProvider = LocalDataProvider<HistoryRecord>

// MARK: - ServiceProvider

/// Services provider for SearchEngine
public class ServiceProvider: ServiceProviderProtocol {
    /// Customize API host URL with a value from the Info.plist
    /// Also supports reading a process argument when in non-Release UITest builds
    public static var customBaseURL: String? {
#if !RELEASE
        if ProcessInfo.processInfo.arguments.contains(where: { $0 == "--uitesting" }) {
            let testingBaseUrl = ProcessInfo.processInfo.environment["search_endpoint"]
            return testingBaseUrl
        }
#endif

        return Bundle.main.object(forInfoDictionaryKey: baseURLPlistKey) as? String
    }

    /// LocalDataProvider for favorites records
    public let localFavoritesProvider = FavoritesProvider()
    /// LocalDataProvider for history records
    public let localHistoryProvider = HistoryProvider()
    /// MapboxMobileEvents manager for analytics usage
    public let eventsManager = EventsManager()

    /// Responsible for sending feedback related events.
    public private(set) lazy var feedbackManager = FeedbackManager(eventsManager: eventsManager)

    /// Shared instance of ServiceProvider
    public static let shared = ServiceProvider()

    var dataLayerProviders: [IndexableDataProvider] { [localHistoryProvider, localFavoritesProvider] }
}

extension ServiceProvider: EngineProviderProtocol {
    func getStoredAccessToken() -> String? {
        Bundle.main.object(forInfoDictionaryKey: accessTokenPlistKey) as? String
    }

    func createEngine(
        apiType: CoreSearchEngine.ApiType,
        accessToken: String,
        locationProvider: CoreLocationProvider?
    ) -> CoreSearchEngineProtocol {
        let engineOptions = CoreSearchEngine.Options(
            accessToken: accessToken,
            baseUrl: Self.customBaseURL,
            apiType: NSNumber(value: apiType.rawValue),
            userAgent: eventsManager.userAgentName,
            eventsUrl: nil
        )

        return CoreSearchEngine(
            options: engineOptions,
            location: locationProvider
        )
    }
}
