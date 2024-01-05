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
    private let userActivityReporter: CoreUserActivityReporterProtocol
    
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
                sdkInformation: CoreSdkInformation(name: "", version: "", packageName: ""),
                eventsUrl: nil
            )
        )
        
        self.init(searchEngine: searchEngine, userActivityReporter: userActivityReporter)
    }
    
    init(searchEngine: CoreSearchEngineProtocol, userActivityReporter: CoreUserActivityReporterProtocol) {
        self.searchEngine = searchEngine
        self.userActivityReporter = userActivityReporter
    }
}

// MARK: - Public API
public extension PlaceAutocomplete {
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - query: Text query for suggestions.
    ///   - region: Limit results to only those contained within the supplied bounding box.
    ///   - proximity: Optional geographic point that bias the response to favor results that are closer to this location.
    ///   - options: Search options used for filtration.
    ///   - completion: Result of the suggestion request, one of error or value.
    func suggestions(
        for query: String,
        region: BoundingBox? = nil,
        proximity: CLLocationCoordinate2D? = nil,
        filterBy options: Options = .init(),
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "place-autocomplete-forward-geocoding")

        var navigationOptions: SearchNavigationOptions?
        if let navigationProfiler = options.navigationProfile {
            navigationOptions = .init(profile: navigationProfiler, etaType: .navigation)
        }
        
        // We should not leave core types list empty or null in order to avoid unsupported types being requested
        var filterTypes = options.types
        if filterTypes.isEmpty {
            filterTypes = PlaceType.allTypes
        }
        
        let searchOptions = SearchOptions(
            countries: options.countries.map { $0.countryCode },
            languages: [options.language.languageCode],
            limit: Constants.defaultSuggestionsLimit,
            proximity: proximity,
            boundingBox: region,
            origin: proximity,
            navigationOptions: navigationOptions,
            filterTypes: filterTypes.map { $0.coreType },
            ignoreIndexableRecords: true
        ).toCore(apiType: Self.apiType)
        
        fetchSuggestions(for: query, with: searchOptions, completion: completion)
    }
    
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - query: Coordinates query.
    ///   - options: Search options used for filtration.
    ///   - completion: Result of the suggestion request, one of error or value.
    func suggestions(
        for query: CLLocationCoordinate2D,
        filterBy options: Options = .init(),
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "place-autocomplete-reverse-geocoding")
        
        // We should not leave core types list empty or null in order to avoid unsupported types being requested
        var filterTypes = options.types
        if filterTypes.isEmpty {
            filterTypes = PlaceType.allTypes
        }
        
        let searchOptions = ReverseGeocodingOptions(
            point: query,
            types: filterTypes.map { $0.coreType },
            countries: options.countries.map { $0.countryCode },
            languages: [options.language.languageCode]
        ).toCore()
        
        fetchSuggestions(using: searchOptions, completion: completion)
    }

    /// Retrieves detailed information about the `PlaceAutocomplete.Suggestion`.
    /// Use this function to end search session even if you don't need detailed information.
    ///
    /// Subject to change: in future, you may be charged for a suggestion call in case your UX flow
    /// accepts one of suggestions as selected and uses the coordinates,
    /// but you don’t call `select(suggestion:completion:)` method to confirm this.
    /// Other than that suggestions calls are not billed.
    ///
    /// - Parameters:
    ///   - suggestion: Suggestion to select.
    ///   - completion: Result of the suggestion selection, one of error or value.
    func select(
        suggestion: Suggestion,
        completion: @escaping (Swift.Result<PlaceAutocomplete.Result, Error>
        ) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "place-autocomplete-suggestion-select")

        switch suggestion.underlying {
        case .result(let searchResult):
            let autocompleteResult = suggestion.result(for: searchResult)
            completion(.success(autocompleteResult))
            
        case .suggestion(let searchSuggestion, let options):
            retrieve(underlyingSuggestion: searchSuggestion, with: options, completion: completion)
        }
    }
}

// MARK: - Reverse geocoding query
private extension PlaceAutocomplete {
    func fetchSuggestions(using options: CoreReverseGeoOptions, completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void) {
        searchEngine.reverseGeocoding(for: options) { response in
            guard let response = Self.preprocessResponse(response) else {
                return
            }
            
            switch response.process() {
            case .success(let processedResponse):
                do {
                    let suggestions = try processedResponse.results.map { try Suggestion.from($0) }
                    completion(.success(suggestions))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
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

    func retrieve(
        suggestion: CoreSearchResultProtocol,
        with options: CoreRequestOptions,
        completion: @escaping (Swift.Result<Suggestion, Error>) -> Void
    ) {
        searchEngine.nextSearch(for: suggestion, with: options) { response in
            guard let coreResponse = response else {
                assertionFailure("Response should never be nil")
                completion(.failure(SearchError.responseProcessingFailed))
                return
            }

            guard let response = Self.preprocessResponse(coreResponse) else {
                completion(.failure(SearchError.responseProcessingFailed))
                return
            }

            switch response.process() {
            case .success(let processedResponse):
                guard let result = processedResponse.results.first else {
                    completion(.failure(SearchError.responseProcessingFailed))
                    return
                }
                do {
                    let resolvedSuggestion = try Suggestion.from(result)
                    completion(.success(resolvedSuggestion))
                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func retrieve(
        underlyingSuggestion: CoreSearchResultProtocol,
        with options: CoreRequestOptions,
        completion: @escaping (Swift.Result<PlaceAutocomplete.Result, Error>) -> Void
    ) {
        retrieve(suggestion: underlyingSuggestion, with: options) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let resolvedSuggestion):
                guard case let .result(underlyingResult) = resolvedSuggestion.underlying else {
                    completion(.failure(SearchError.responseProcessingFailed))
                    return
                }
                completion(.success(resolvedSuggestion.result(for: underlyingResult)))
            }
        }
    }

    func resolve(
        suggestions: [CoreSearchResult],
        with options: CoreRequestOptions,
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        let filteredSuggestions = suggestions.filter {
            !$0.resultTypes.contains(.category) && !$0.resultTypes.contains(.query)
        }
        guard !filteredSuggestions.isEmpty else {
            return completion(.success([]))
        }
        
        let dispatchGroup = DispatchGroup()
        var resolvingError: Error?
        
        var resolvedSuggestions: [Suggestion?] = Array(repeating: nil, count: filteredSuggestions.count)
        let lock = NSLock()

        filteredSuggestions.enumerated().forEach { iterator in
            dispatchGroup.enter()

            if iterator.element.center != nil {
                do {
                    let resolvedSuggestion = try Suggestion.from(searchSuggestion: iterator.element, options: options)
                    lock.sync {
                        resolvedSuggestions[iterator.offset] = resolvedSuggestion
                    }
                } catch {
                    resolvingError = error
                }
                dispatchGroup.leave()
            } else {
                retrieve(suggestion: iterator.element, with: options) { result in
                    defer { dispatchGroup.leave() }

                    switch result {
                    case .success(let suggestion):
                        lock.sync {
                            resolvedSuggestions[iterator.offset] = suggestion
                        }
                    case .failure(let error):
                        resolvingError = error
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let results = resolvedSuggestions.compactMap({ $0 })
            if results.isEmpty {
                completion(.failure(resolvingError ?? SearchError.responseProcessingFailed))
            } else {
                completion(.success(results))
            }
        }
    }
}
