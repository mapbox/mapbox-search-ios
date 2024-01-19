import CoreLocation
import Foundation

public final class Discover {
    private let searchEngine: CategorySearchEngine
    private let userActivityReporter: CoreUserActivityReporter

    /// Basic internal initializer
    /// - Parameters:
    ///   - accessToken: Mapbox Access Token to be used. Info.plist value for key `MGLMapboxAccessToken` will be used
    /// for `nil` argument
    ///   - locationProvider: Provider configuration of LocationProvider that would grant location data by default
    public convenience init(
        accessToken: String? = nil,
        locationProvider: LocationProvider? = DefaultLocationProvider()
    ) {
        guard let accessToken = accessToken ?? ServiceProvider.shared.getStoredAccessToken() else {
            fatalError(
                "No access token was found. Please, provide it in init(accessToken:) or in Info.plist at '\(accessTokenPlistKey)' key"
            )
        }

        let searchEngine = CategorySearchEngine(
            accessToken: accessToken,
            locationProvider: locationProvider,
            supportSBS: true
        )

        let userActivityReporter = CoreUserActivityReporter.getOrCreate(
            for: CoreUserActivityReporterOptions(
                accessToken: accessToken,
                userAgent: defaultUserAgent,
                eventsUrl: nil
            )
        )

        self.init(searchEngine: searchEngine, userActivityReporter: userActivityReporter)
    }

    init(searchEngine: CategorySearchEngine, userActivityReporter: CoreUserActivityReporter) {
        self.searchEngine = searchEngine
        self.userActivityReporter = userActivityReporter
    }
}

extension Discover {
    /// Search for places nearby the specified geographic point.
    /// - Parameters:
    ///   - query: Search query
    ///   - proximity: Geographic point to search nearby.
    ///   - options: Search options
    ///   - completion: Result of the search request, one of error or value.
    ///
    public func search(
        for query: Query,
        proximity: CLLocationCoordinate2D,
        options: Options = .init(),
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "discover-search-nearby")

        let searchOptions = SearchOptions(
            languages: [options.language.languageCode],
            limit: options.limit,
            proximity: proximity
        )

        search(for: query, with: searchOptions, completion: completion)
    }

    /// Search for places nearby the specified geographic point.
    /// - Parameters:
    ///   - query: Search query
    ///   - region:  Limit results to only those contained within the supplied bounding box.
    ///   - proximity: Optional geographic point to search nearby.
    ///   - options: Search options
    ///   - completion: Result of the search request, one of error or value.
    ///
    public func search(
        for query: Query,
        in region: BoundingBox,
        proximity: CLLocationCoordinate2D? = nil,
        options: Options = .init(),
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "discover-search-in-area")

        let searchOptions = SearchOptions(
            languages: [options.language.languageCode],
            limit: options.limit,
            proximity: proximity,
            boundingBox: region
        )

        search(for: query, with: searchOptions, completion: completion)
    }

    /// Search for places nearby the specified geographic point.
    /// - Parameters:
    ///   - query: Search query
    ///   - route: Route to search across (points and deviation options).
    ///   - options: Search options
    ///   - completion: Result of the search request, one of error or value.
    ///
    public func search(
        for query: Query,
        route: RouteOptions,
        options: Options = .init(),
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "discover-search-along-the-route")

        let searchOptions = SearchOptions(
            languages: [options.language.languageCode],
            limit: options.limit,
            routeOptions: route
        )

        search(for: query, with: searchOptions, completion: completion)
    }
}

// MARK: - Private

extension Discover {
    private func search(
        for query: Query,
        with searchOptions: SearchOptions,
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        searchEngine.search(
            categoryName: query.rawValue,
            options: searchOptions
        ) { result in
            switch result {
            case .success(let searchResults):
                let discoverResults = searchResults.map(Discover.Result.from(_:))
                completion(.success(discoverResults))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
