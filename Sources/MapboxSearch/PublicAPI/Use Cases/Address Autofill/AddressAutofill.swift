// Copyright © 2022 Mapbox. All rights reserved.

import Foundation
import CoreLocation

public final class AddressAutofill {
    private let searchEngine: CoreSearchEngineProtocol
    
    private static var apiType: CoreSearchEngine.ApiType {
        return .SBS
    }
    
    /// Basic internal initializer
    /// - Parameters:
    ///   - accessToken: Mapbox Access Token to be used. Info.plist value for key `MGLMapboxAccessToken` will be used for `nil` argument
    public convenience init(accessToken: String? = nil) {
        guard let accessToken = accessToken ?? ServiceProvider.shared.getStoredAccessToken() else {
            fatalError("No access token was found. Please, provide it in init(accessToken:) or in Info.plist at '\(accessTokenPlistKey)' key")
        }
        
        let searchEngine = ServiceProvider.shared.createEngine(
            apiType: Self.apiType,
            accessToken: accessToken,
            locationProvider: WrapperLocationProvider(wrapping: DefaultLocationProvider())
        )
        
        self.init(searchEngine: searchEngine)
    }
    
    init(searchEngine: CoreSearchEngineProtocol) {
        self.searchEngine = searchEngine
    }
}

// MARK: - Public API
public extension AddressAutofill {
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - query: query string to search
    ///   - options: if no value provided Search Engine will use options from requestOptions field
    func suggestions(for query: String, with options: Options? = nil, completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void) {
        let searchOptions = SearchOptions(
            countries: options?.countries.map { $0.countryCode },
            languages: options.map { [$0.language.languageCode] },
            filterTypes: acceptedTypes,
            ignoreIndexableRecords: true
        ).toCore(apiType: Self.apiType)
        
        fetchSuggestions(for: query, with: searchOptions, completion: completion)
    }
    
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - coordinate: point Coordinate to resolve
    ///   - options: if no value provided Search Engine will use options from requestOptions field
    func suggestion(for coordinate: CLLocationCoordinate2D, with options: Options? = nil, completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void) {
        let searchOptions = ReverseGeocodingOptions(
            point: coordinate,
            types: acceptedTypes,
            countries: options?.countries.map { $0.countryCode },
            languages: options.map { [$0.language.languageCode] }
        ).toCore()
        
        fetchSuggestions(using: searchOptions, completion: completion)
    }
}

// MARK: - Reverse geocoding query
private extension AddressAutofill {
    func fetchSuggestions(using options: CoreReverseGeoOptions, completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void) {
        searchEngine.reverseGeocoding(for: options) { response in
            guard let response = response else {
                assertionFailure("Response should never be nil")
                return
            }
            
            switch response.result {
            case .success(let results):
                // HANDLE SUCCESS
                print(results.count)
                
            case .failure(let responseError):
                // TODO: handle errors
                completion(
                    .failure(.underlying(responseError))
                )
            }
        }
    }
}

// MARK: - Text query
private extension AddressAutofill {
    var acceptedTypes: [SearchQueryType] {
        [.country, .region, .postcode, .district, .place, .locality, .neighborhood, .address, .street]
    }

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
        guard let response = Self.preprocessResponse(coreResponse, for: query) else {
            return
        }
        
        switch response.coreResponse.result {
        case .success(let coreResults):
            resolve(suggestions: coreResults, for: query, with: response.coreResponse.request, completion: completion)
            
        case .failure(let error):
            // TODO: handle errors
            completion(.failure(.underlying(error)))
        }
    }
    
    static func preprocessResponse(_ coreResponse: CoreSearchResponseProtocol?, for query: String) -> SearchResponse? {
        assert(Thread.isMainThread)
        
        guard let coreResponse = coreResponse else {
            assertionFailure("Response should never be nil")
            return nil
        }
        
        guard coreResponse.request.query == query else {
            return nil
        }
        
        return SearchResponse(coreResponse: coreResponse)
    }
    
    func resolve(suggestions: [CoreSearchResult], for query: String, with options: CoreRequestOptions, completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void) {
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
                
                guard let response = Self.preprocessResponse(coreResponse, for: query) else {
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
                    // TODO: handle errors
                    completion(.failure(.underlying(error)))
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print(resolvedResultsUnsafe.count)
        }
    }
}
