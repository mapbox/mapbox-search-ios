import Foundation
import CoreLocation

private extension AddressAutofill {
    enum Constants {
        static let defaultSuggestionsLimit = 10
    }
}

public final class AddressAutofill {
    private let searchEngine: CoreSearchEngineProtocol
    private let userActivityReporter: CoreUserActivityReporterProtocol

    private static var apiType: CoreSearchEngine.ApiType {
        return .autofill
    }

    /// Basic internal initializer
    /// - Parameters:
    ///   - locationProvider: Provider configuration of LocationProvider that would grant location data by default
    public convenience init(locationProvider: LocationProvider? = DefaultLocationProvider()) {
        let searchEngine = ServiceProvider.shared.createEngine(
            apiType: Self.apiType,
            locationProvider: WrapperLocationProvider(wrapping: locationProvider)
        )

        let userActivityReporter = CoreUserActivityReporter.getOrCreate(
            for: CoreUserActivityReporterOptions(
                sdkInformation: SdkInformation.defaultInfo,
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

public extension AddressAutofill {
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - query: query string to search
    ///   - options: if no value provided Search Engine will use options from requestOptions field
    func suggestions(
        for query: Query,
        with options: Options? = nil,
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "address-autofill-forward-geocoding")

        let searchOptions = SearchOptions(
            countries: options?.countries.map { $0.countryCode },
            languages: options.map { [$0.language.languageCode] },
            limit: Constants.defaultSuggestionsLimit,
            ignoreIndexableRecords: true
        ).toCore(apiType: Self.apiType)

        fetchSuggestions(for: query.value, with: searchOptions, completion: completion)
    }

    /// Start searching for query with provided options
    /// - Parameters:
    ///   - coordinate: point Coordinate to resolve
    ///   - options: if no value provided Search Engine will use options from requestOptions field
    func suggestions(
        for coordinate: CLLocationCoordinate2D,
        with options: Options? = nil,
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "address-autofill-reverse-geocoding")

        let searchOptions = ReverseGeocodingOptions(
            point: coordinate,
            countries: options?.countries.map { $0.countryCode },
            languages: options.map { [$0.language.languageCode] }
        ).toCore()

        fetchSuggestions(using: searchOptions, completion: completion)
    }

    /// Retrieves detailed information about the `AddressAutofill.Suggestion`.
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
        completion: @escaping (Swift.Result<AddressAutofill.Result, Error>
        ) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "address-autofill-suggestion-select")

        switch suggestion.underlying {
        case let .suggestion(coreSearch, coreOptions):
            searchEngine.nextSearch(for: coreSearch, with: coreOptions) { [weak self] coreResponse in
                guard let self = self else { return }

                self.manage(response: coreResponse, completion: completion)
            }
        case .result:
            guard let coordinate = suggestion.coordinate else {
                completion(.failure(SearchError.responseProcessingFailed))
                return
            }
            let result = AddressAutofill.Result(
                name: suggestion.name,
                formattedAddress: suggestion.formattedAddress,
                coordinate: coordinate,
                addressComponents: suggestion.addressComponents
            )
            completion(.success(result))
        }
    }
}

// MARK: - Reverse geocoding query

private extension AddressAutofill {
    func fetchSuggestions(
        using options: CoreReverseGeoOptions,
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
        searchEngine.reverseGeocoding(for: options) { response in
            guard let response = Self.preprocessResponse(response) else {
                return
            }

            switch response.coreResponse.result {
            case .success(let remoteResults):
                let suggestions: [Suggestion] = remoteResults.compactMap { remoteResult -> Suggestion? in
                    do {
                        return try ServerSearchResult(
                            coreResult: remoteResult,
                            response: response.coreResponse
                        )
                        .map(Suggestion.from(_:))
                    } catch {
                        return nil
                    }
                }
                completion(.success(suggestions))

            case .failure(let responseError):
                completion(
                    .failure(responseError)
                )
            }
        }
    }
}

// MARK: - Suggestion Text query

private extension AddressAutofill {
    func fetchSuggestions(
        for query: String,
        with options: CoreSearchOptions,
        completion: @escaping (Swift.Result<[Suggestion], Error>) -> Void
    ) {
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
        let resolvedSuggestions = suggestions.compactMap { result -> Suggestion? in
            guard let name = result.names.first,
                  let address = result.addresses?.first,
                  let resultAddress = try? address.toAutofillComponents() else {
                return nil
            }

            let fullAddress = result.fullAddress ?? ""
            let underlying: Suggestion.Underlying = .suggestion(result, options)

            return Suggestion(name: name,
                              formattedAddress: fullAddress,
                              coordinate: result.center?.value,
                              addressComponents: resultAddress,
                              underlying: underlying)
        }

        completion(.success(resolvedSuggestions))
    }
}

// MARK: - Suggestion Retrieval Query

private extension AddressAutofill {
    /// Manage responses from retrieve invocations.
    /// - Parameters:
    ///   - coreResponse: Response from retrieve endpoint for a given suggestion.
    ///   - completion: Completion to execute when done processing response.
    func manage(
        response coreResponse: CoreSearchResponseProtocol?,
        completion: @escaping (Swift.Result<AddressAutofill.Result, Error>) -> Void
    ) {
        guard let response = Self.preprocessResponse(coreResponse) else {
            completion(.failure(SearchError.responseProcessingFailed))
            return
        }

        switch response.process() {
        case .success(let success):
            guard let result = success.results.first,
                  let formattedAddress = result.address?.formattedAddress(style: .full),
                  let addressComponents = try? result.address?.toAutofillComponents() else {
                completion(.failure(SearchError.responseProcessingFailed))
                return
            }

            let autofillResult = AddressAutofill.Result(name: result.name,
                                                        formattedAddress: formattedAddress,
                                                        coordinate: result.coordinate,
                                                        addressComponents: addressComponents)

            completion(.success(autofillResult))
        case .failure(let failure):
            completion(.failure(failure))
        }
    }
}
