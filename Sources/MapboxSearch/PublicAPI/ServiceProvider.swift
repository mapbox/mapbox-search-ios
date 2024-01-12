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

/// Services provider for SearchEngine
public class ServiceProvider: ServiceProviderProtocol {
    /// Customize API host URL
    public static var customBaseURL: String? {
        Bundle.main.object(forInfoDictionaryKey: baseURLPlistKey) as? String
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
        // UserDefaults can be used to setup base url in runtime (e.g. UI tests)
        // UserDefaults can be used to setup base url in runtime (e.g. UI tests)
        let defaultsBaseURL = UserDefaults.standard.value(forKey: baseURLPlistKey) as? String
        let bundleBaseURL = Bundle.main.object(forInfoDictionaryKey: baseURLPlistKey) as? String

        MapboxOptions.accessToken = accessToken

        let engineOptions = CoreSearchEngine.Options(
            baseUrl: bundleBaseURL ?? defaultsBaseURL,
            apiType: NSNumber(value: apiType.rawValue),
            sdkInformation: SdkInformation.defaultInfo,
            eventsUrl: nil
        )

        return CoreSearchEngine(
            options: engineOptions,
            location: locationProvider
        )
    }
}
