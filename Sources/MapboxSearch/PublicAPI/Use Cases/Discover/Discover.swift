import CoreLocation
import Foundation

public final class Discover {
    private let searchEngine: CategorySearchEngine
    private let userActivityReporter: CoreUserActivityReporter

    public let apiType: ApiType

    /// Basic internal initializer
    /// - Parameters:
    ///   - accessToken: Mapbox Access Token to be used. Info.plist value for key `MBXAccessToken` will be used
    /// for `nil` argument
    ///   - locationProvider: Provider configuration of `LocationProvider` that would grant location data by default
    ///   - apiType:  Specifies which API provider to use through this search feature. Defaults to ``ApiType/searchBox``.
    public convenience init(
        accessToken: String? = nil,
        locationProvider: LocationProvider? = DefaultLocationProvider(),
        apiType: ApiType = .searchBox
    ) {
        guard let accessToken = accessToken ?? ServiceProvider.shared.getStoredAccessToken() else {
            fatalError(
                "No access token was found. Please, provide it in init(accessToken:) or in Info.plist at '\(accessTokenPlistKey)' key"
            )
        }

        let searchEngine = CategorySearchEngine(
            accessToken: accessToken,
            locationProvider: locationProvider,
            apiType: apiType
        )

        let userActivityReporter = CoreUserActivityReporter.getOrCreate(
            for: CoreUserActivityReporterOptions(
                sdkInformation: SdkInformation.defaultInfo,
                eventsUrl: nil
            )
        )

        self.init(searchEngine: searchEngine, userActivityReporter: userActivityReporter)
    }

    init(searchEngine: CategorySearchEngine, userActivityReporter: CoreUserActivityReporter) {
        self.searchEngine = searchEngine
        self.apiType = searchEngine.apiType
        self.userActivityReporter = userActivityReporter
    }
}

extension Discover {
    /// Search for places nearby the specified geographic point.
    /// - Parameters:
    ///   - item: Search item
    ///   - proximity: Geographic point to search nearby.
    ///   - options: Search options
    ///   - completion: Result of the search request, one of error or value.
    ///
    public func search(
        for item: Discover.Query,
        proximity: CLLocationCoordinate2D,
        options: Options = .init(),
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "category-search-nearby")
        let searchOptions = SearchOptions(
            countries: [options.country?.countryCode].compactMap { $0 },
            languages: [options.language.languageCode],
            limit: options.limit,
            proximity: proximity,
            origin: options.origin
        )

        search(for: item, with: searchOptions, completion: completion)
    }

    /// Search for places nearby the specified geographic point.
    /// - Parameters:
    ///   - item: Search query.
    ///   - region:  Limit results to only those contained within the supplied bounding box.
    ///   - proximity: Optional geographic point to search nearby.
    ///   - options: Search options
    ///   - completion: Result of the search request, one of error or value.
    ///
    public func search(
        for item: Discover.Query,
        in region: BoundingBox,
        proximity: CLLocationCoordinate2D? = nil,
        options: Options = .init(),
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "category-search-in-area")
        let searchOptions = SearchOptions(
            countries: [options.country?.countryCode].compactMap { $0 },
            languages: [options.language.languageCode],
            limit: options.limit,
            proximity: proximity ?? options.proximity,
            boundingBox: region,
            origin: options.origin
        )

        search(for: item, with: searchOptions, completion: completion)
    }

    /// Search for places nearby the specified geographic point.
    /// - Parameters:
    ///   - item: Search item
    ///   - route: Route to search across (points and deviation options).
    ///   - options: Search options
    ///   - completion: Result of the search request, one of error or value.
    ///
    public func search(
        for item: Discover.Query,
        route: RouteOptions,
        options: Options = .init(),
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "category-search-along-the-route")

        let searchOptions = SearchOptions(
            countries: [options.country?.countryCode].compactMap { $0 },
            languages: [options.language.languageCode],
            limit: options.limit,
            proximity: options.proximity,
            origin: options.origin,
            routeOptions: route
        )

        search(for: item, with: searchOptions, completion: completion)
    }
}

// MARK: - Private

extension Discover {
    private func search(
        for item: Discover.Query,
        with searchOptions: SearchOptions,
        completion: @escaping (Swift.Result<[Result], Error>) -> Void
    ) {
        searchEngine.search(
            categoryName: item.rawValue,
            options: searchOptions
        ) { result in
            switch result {
            case .success(let searchResults):
                let categoryResults = searchResults.map(Discover.Result.from(_:))
                completion(.success(categoryResults))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
