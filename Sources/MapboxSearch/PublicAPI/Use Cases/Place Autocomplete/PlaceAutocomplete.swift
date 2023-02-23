// Copyright © 2022 Mapbox. All rights reserved.

import Foundation
import CoreLocation

private extension PlaceAutocomplete {
    enum Constants {
        static let defaultSuggestionsLimit = 10
    }
}

/// Main entrypoint to the Mapbox Place Autocomplete SDK.
public final class PlaceAutocomplete {
    private let searchEngine: CoreSearchEngineProtocol
    private let userActivityReporter: CoreUserActivityReporter
    
    private static var apiType: CoreSearchEngine.ApiType {
        return .SBS
    }

    /// Basic internal initializer
    /// - Parameters:
    ///   - accessToken: Mapbox Access Token to be used. Info.plist value for key `MGLMapboxAccessToken` will be used for `nil` argument
    ///   - locationProvider: Provider configuration of LocationProvider that would grant location data by default
    public convenience init(
        accessToken: String? = nil,
        locationProvider: LocationProvider? = DefaultLocationProvider()
    ) {
        guard let accessToken = accessToken ?? ServiceProvider.shared.getStoredAccessToken() else {
            fatalError("No access token was found. Please, provide it in init(accessToken:) or in Info.plist at '\(accessTokenPlistKey)' key")
        }
        
        let searchEngine = ServiceProvider.shared.createEngine(
            apiType: Self.apiType,
            accessToken: accessToken,
            locationProvider: WrapperLocationProvider(wrapping: locationProvider)
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
    
    init(searchEngine: CoreSearchEngineProtocol, userActivityReporter: CoreUserActivityReporter) {
        self.searchEngine = searchEngine
        self.userActivityReporter = userActivityReporter
    }
}

// MARK: - Public API
public extension PlaceAutocomplete {
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - query: text query for suggestions
    ///   - proximity: proximity Optional geographic point that bias the response to favor results that are closer to this location.
    ///   - options: Search options used for filtration
    func suggestions(
        for query: String,
        region: BoundingBox? = nil,
        proximity: CLLocationCoordinate2D? = nil,
        filterBy options: Options = .init(),
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "place-autocomplete-forward-geocoding")
        
        let searchOptions = SearchOptions(
            countries: options.countries.map { $0.countryCode },
            languages: [options.language.languageCode],
            limit: Constants.defaultSuggestionsLimit,
            proximity: proximity,
            boundingBox: region,
            filterTypes: options.types.isEmpty ? nil : options.types.map { $0.coreType },
            ignoreIndexableRecords: true
        ).toCore(apiType: Self.apiType)
        
        fetchSuggestions(for: query, with: searchOptions, completion: completion)
    }
    
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - coordinate: coordinates query
    ///   - options: Search options used for filtration
    func suggestions(
        for query: CLLocationCoordinate2D,
        filterBy options: Options = .init(),
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "place-autocomplete-reverse-geocoding")
        
        let searchOptions = ReverseGeocodingOptions(
            point: query,
            types: options.types.map { $0.coreType },
            countries: options.countries.map { $0.countryCode },
            languages: [options.language.languageCode]
        ).toCore()
        
        fetchSuggestions(using: searchOptions, completion: completion)
    }
}

// MARK: - Reverse geocoding query
private extension PlaceAutocomplete {
    func fetchSuggestions(using options: CoreReverseGeoOptions, completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void) {
        searchEngine.reverseGeocoding(for: options) { [weak self] response in
            guard let response = Self.preprocessResponse(response) else {
                return
            }
            
            switch response.coreResponse.result {
            case .success(let results):
                self?.resolve(suggestions: results, with: response.coreResponse.request, completion: completion)
                
            case .failure(let responseError):
                completion(
                    .failure(responseError)
                )
            }
        }
    }
}


// MARK: - Text query handling
private extension PlaceAutocomplete {
    func fetchSuggestions(for query: String, with options: CoreSearchOptions, completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void) {
        searchEngine.search(
            forQuery: query,
            categories: [],
            options: options
        ) { [weak self] response in
            guard let self = self else { return }
                
            self.manage(response: response, for: query, completion: completion)
        }
    }
    
    func manage(
        response coreResponse: CoreSearchResponseProtocol?,
        for query: String,
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        enum ResponseError: Error {
            case unknown
        }
        
        guard let response = Self.preprocessResponse(coreResponse) else {
            return completion(
                .failure(SearchError.responseProcessingFailed)
            )
        }
        
        switch response.coreResponse.result {
        case .success(let coreResults):
            resolve(suggestions: coreResults, with: response.coreResponse.request, completion: completion)
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    static func preprocessResponse(_ coreResponse: CoreSearchResponseProtocol?) -> SearchResponse? {
        assert(Thread.isMainThread)
        
        guard let coreResponse = coreResponse else {
            assertionFailure("Response should never be nil")
            return nil
        }
    
        return SearchResponse(coreResponse: coreResponse)
    }
    
    func resolve(
        suggestions: [CoreSearchResult],
        with options: CoreRequestOptions,
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        guard !suggestions.isEmpty else {
            return completion(.success([]))
        }
        
        let dispatchGroup = DispatchGroup()
        
        var resolvedResultsUnsafe: [SearchResult?] = Array(repeating: nil, count: suggestions.count)
        let lock = NSLock()

        suggestions.enumerated().forEach { iterator in
            dispatchGroup.enter()
            
            searchEngine.nextSearch(for: iterator.element, with: options) { response in
                defer { dispatchGroup.leave() }
                
                guard let coreResponse = response else {
                    assertionFailure("Response should never be nil")
                    return
                }
                
                guard let response = Self.preprocessResponse(coreResponse) else {
                    return
                }
                
                switch response.process() {
                case .success(let processedResponse):
                    guard let result = processedResponse.results.first else {
                        return
                    }
                
                    lock.sync {
                        resolvedResultsUnsafe[iterator.offset] = result
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let resolvedSuggestions: [Suggestion] = resolvedResultsUnsafe.compactMap {
                do {
                    return try $0.map(Suggestion.from(_:))
                } catch {
                    return nil
                }
            }
            
            completion(.success(resolvedSuggestions))
        }
    }
}
