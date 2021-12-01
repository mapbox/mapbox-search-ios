import MapboxMobileEvents
@testable import MapboxSearch

class ServiceProviderStub: ServiceProviderProtocol, EngineProviderProtocol {
    func getStoredAccessToken() -> String? {
        "mapbox-access-token"
    }
    
    lazy var dataLayerProviders: [IndexableDataProvider] = [localFavoritesProvider, localHistoryProvider]
    
    let localFavoritesProvider = LocalDataProvider<FavoriteRecord>()
    let localHistoryProvider = LocalDataProvider<HistoryRecord>()
    lazy var eventsManager = EventsManager(telemetry: telemetryStub)
    lazy var feedbackManager = FeedbackManager(eventsManager: eventsManager)
    
    let telemetryStub = TelemetryManagerStub()
    
    var latestCoreEngine: CoreSearchEngineStub!

    func createEngine(apiType: CoreSearchEngine.ApiType, accessToken: String, platformClient: CorePlatformClient, locationProvider: CoreLocationProvider?) -> CoreSearchEngineProtocol {
        let locationProvider: CoreLocationProvider? = WrapperLocationProvider(wrapping: DefaultLocationProvider())
        latestCoreEngine = CoreSearchEngineStub(accessToken: "mapbox-access-token", client: platformClient, location: locationProvider)
        return latestCoreEngine
    }
}
