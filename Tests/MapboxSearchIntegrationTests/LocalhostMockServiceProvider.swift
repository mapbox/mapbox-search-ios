@testable import MapboxSearch
import XCTest

class LocalhostMockServiceProvider: ServiceProviderProtocol {
    public static var customBaseURL: String?

    /// LocalDataProvider for favorites records
    public let localFavoritesProvider = FavoritesProvider()
    /// LocalDataProvider for history records
    public let localHistoryProvider = HistoryProvider()
    /// MapboxMobileEvents manager for analytics usage
    public let eventsManager = EventsManager()

    /// Responsible for sending feedback related events.
    public private(set) lazy var feedbackManager = FeedbackManager(eventsManager: eventsManager)

    /// Shared instance of ServiceProvider
    public static let shared = LocalhostMockServiceProvider()

    var dataLayerProviders: [IndexableDataProvider] { [localHistoryProvider, localFavoritesProvider] }
}

extension LocalhostMockServiceProvider: EngineProviderProtocol {
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
            userAgent: "mapbox-search-ios-tests",
            eventsUrl: nil
        )

        return CoreSearchEngine(
            options: engineOptions,
            location: locationProvider
        )
    }
}
