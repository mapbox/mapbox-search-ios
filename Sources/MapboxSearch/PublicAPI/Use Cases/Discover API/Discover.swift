// Copyright © 2023 Mapbox. All rights reserved.

import Foundation
import CoreLocation

public final class Discover {
    private let searchEngine: CategorySearchEngine
    private let userActivityReporter: CoreUserActivityReporter
    
    /// Basic internal initializer
    /// - Parameters:
    ///   - locationProvider: Provider configuration of LocationProvider that would grant location data by default
    public convenience init(
        locationProvider: LocationProvider? = DefaultLocationProvider()
    ) {
        let searchEngine = CategorySearchEngine(
            locationProvider: locationProvider,
            supportSBS: true
        )
        
        let userActivityReporter = CoreUserActivityReporter.getOrCreate(
            for: CoreUserActivityReporterOptions(
                sdkInformation: SdkInformation.info(),
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

public extension Discover {
    /// Search for places nearby the specified geographic point.
    /// - Parameters:
    ///   - query: Search query
    ///   - proximity: Geographic point to search nearby.
    ///   - options: Search options
    ///   - completion: Result of the search request, one of error or value.
    ///
    func search(
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
    func search(
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
    func search(
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
private extension Discover {
    func search(
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
