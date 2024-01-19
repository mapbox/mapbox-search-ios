import CoreLocation
import CwlPreconditionTesting
@testable import MapboxSearch
import XCTest

class SearchEngineTests: XCTestCase {
    var delegate = SearchEngineDelegateStub()
    let provider = ServiceProviderStub()

    override func setUp() {
        super.setUp()

        provider.localHistoryProvider.clearData()
        provider.localFavoritesProvider.clearData()
    }

    func testEmptySearch() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = [CoreSearchResultStub]()

        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            XCTFail("impossible")
        }
    }

    func testMixedSearch() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [expectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            XCTFail("impossible")
        }
    }

    func testReverseGeocodingSearch() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let expectation = XCTestExpectation()
        let point = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)
        searchEngine.reverseGeocoding(options: .init(point: point)) { result in
            if case .success(let reverseGeocodingResults) = result {
                XCTAssertEqual(results.map(\.id), reverseGeocodingResults.map(\.id))
            } else {
                XCTFail("impossible")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testErrorSearch() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let coreResponse = CoreSearchResponseStub.failureSample
        engine.searchResponse = coreResponse
        let expectation = delegate.errorExpectation
        searchEngine.search(query: coreResponse.request.query)
        wait(for: [expectation], timeout: 10)

        XCTAssertEqual([], searchEngine.suggestions.map(\.id))
    }

    func testIgnoreResultsForOutdatedSearchQuery() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(options: .sample1, results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [updateExpectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            XCTFail("impossible")
        }

        engine.searchResponse = CoreSearchResponseStub.successSample(options: .sample2, results: [])

        let expetations = [delegate.updateExpectation, delegate.successExpectation, delegate.errorExpectation]
        expetations.forEach { $0.isInverted = true }
        searchEngine.search(query: "sample-2")
        wait(for: expetations, timeout: 1)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            XCTFail("impossible")
        }
    }

    func testIgnoreErrorForOutdatedSearchQuery() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [updateExpectation], timeout: 10)

        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            XCTFail("impossible")
        }

        engine.searchResponse = CoreSearchResponseStub.failureSample
        let expectations = [delegate.updateExpectation, delegate.successExpectation, delegate.errorExpectation]
        expectations.forEach { $0.isInverted = true }
        searchEngine.search(query: "new_query")
        wait(for: expectations, timeout: 1)
        XCTAssertEqual(results.map(\.id), searchEngine.suggestions.map(\.id))
    }

    func testResolvedSearchResult() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [updateExpectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            XCTFail("impossible")
        }

        let successExpectation = delegate.successExpectation
        let selectedResult = searchEngine.suggestions.first!
        searchEngine.select(suggestion: selectedResult)
        wait(for: [successExpectation], timeout: 10)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)

        XCTAssertEqual(resolvedResult.id, selectedResult.id)
    }

    func testDataLayerProvider() throws {
        let results = CoreSearchResultStub.makeMixedResultsSet()
        results.forEach { $0.customDataLayerIdentifier = DataLayerProviderStub.providerIdentifier }
        let records = [IndexableRecordStub(), IndexableRecordStub(), IndexableRecordStub()]
        let dataLayerProvider = DataLayerProviderStub(records: records)

        let serviceProvider = provider
        serviceProvider.dataLayerProviders.append(dataLayerProvider)
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: serviceProvider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [updateExpectation], timeout: 10)
        if case .success(let results) = response.process() {
            XCTAssertEqual(results.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
        } else {
            XCTFail("impossible")
        }

        let successExpectation = delegate.successExpectation
        let selectedResult = searchEngine.suggestions.first!
        searchEngine.select(suggestion: selectedResult)
        wait(for: [successExpectation], timeout: 10)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)

        XCTAssertEqual(resolvedResult.id, selectedResult.id)
    }

    func testBatchResolve() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let expectation = delegate.batchUpdateExpectation

        let suggestions = CoreSearchResultStub.makeSuggestionsSet().compactMap {
            SearchResultSuggestionImpl(coreResult: $0, response: coreResponse)
        }

        searchEngine.select(suggestions: suggestions)

        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(results.map(\.id), delegate.resolvedResults.map(\.id))
    }

    func testEmptyBatchResolve() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let expectation = delegate.batchUpdateExpectation
        expectation.isInverted = true
        let suggestions: [SearchSuggestion] = []

        searchEngine.select(suggestions: suggestions)
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(delegate.resolvedResults.isEmpty)
    }

    func testSuggestionTypeQuery() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let expectedResults = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: expectedResults)
        engine.searchResponse = coreResponse

        let updateExpectation = delegate.updateExpectation

        let coreSuggestion = CoreSearchResultStub.makeSuggestionTypeQuery()
        coreSuggestion.center = nil
        let suggestion = try XCTUnwrap(SearchResultSuggestionImpl(coreResult: coreSuggestion, response: coreResponse))
        searchEngine.query = "sample-1"
        searchEngine.select(suggestion: suggestion)

        wait(for: [updateExpectation], timeout: 10)
        let results = searchEngine.suggestions

        XCTAssertEqual(expectedResults.map(\.id), results.map(\.id))
    }

    func testBatchResolveFailedResponse() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)

        let expectedError = NSError(
            domain: mapboxCoreSearchErrorDomain,
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Server Internal error"]
        )
        let coreResponse = CoreSearchResponseStub.failureSample(error: expectedError)
        engine.searchResponse = coreResponse
        let expectation = delegate.errorExpectation

        let suggestions = CoreSearchResultStub.makeSuggestionsSet().compactMap {
            SearchResultSuggestionImpl(coreResult: $0, response: coreResponse)
        }

        searchEngine.select(suggestions: suggestions)

        wait(for: [expectation], timeout: 10)

        guard case .generic(let code, let domain, let message) = delegate.error else {
            XCTFail("Generic error expected")
            return
        }
        XCTAssertEqual(expectedError.code, code)
        XCTAssertEqual(expectedError.domain, domain)
        XCTAssertEqual(expectedError.localizedDescription, message)
    }

    func testBatchResolveNoResponse() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        searchEngine.delegate = delegate

        let expectation = delegate.errorExpectation

        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        let suggestions = CoreSearchResultStub.makeSuggestionsSet().compactMap {
            SearchResultSuggestionImpl(coreResult: $0, response: coreResponse)
        }
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        engine.callbackWrapper = { [weak self] callback in
            let assertionError = catchBadInstruction {
                callback()
            }
            do {
                let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
                engine.callbackWrapper = { callback in
                    let assertionError = catchBadInstruction {
                        callback()
                    }
                    XCTAssertNotNil(assertionError)
                }
            } catch {
                XCTFail(error.localizedDescription)
            }
            searchEngine.select(suggestions: suggestions)

            self?.wait(for: [expectation], timeout: 10)

            let expectedError = SearchError.responseProcessingFailed
            XCTAssertEqual(expectedError, self?.delegate.error)
        }
    }

    func testReverseGeocodingNoResponse() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        engine.callbackWrapper = { [weak self] callback in
            let assertionError = catchBadInstruction {
                callback()
            }

            let expectation = XCTestExpectation()
            var error: SearchError?
            let point = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)
            searchEngine.reverseGeocoding(options: .init(point: point)) { result in
                if case .failure(let searchError) = result {
                    error = searchError
                } else {
                    XCTFail("impossible")
                }
                expectation.fulfill()
            }

            self?.wait(for: [expectation], timeout: 10)

            XCTAssertEqual(error, SearchError.responseProcessingFailed)
        }
    }

    func testReverseGeocodingFailedResponse() throws {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let expectedError = NSError(
            domain: mapboxCoreSearchErrorDomain,
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Server Internal error"]
        )
        let coreResponse = CoreSearchResponseStub.failureSample(error: expectedError)
        engine.searchResponse = coreResponse

        let expectation = XCTestExpectation()
        var error: SearchError?
        let point = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)
        searchEngine.reverseGeocoding(options: .init(point: point)) { result in
            if case .failure(let searchError) = result {
                error = searchError
            } else {
                XCTFail("Unexpected")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)

        guard case .reverseGeocodingFailed(let reason, let options) = error else {
            XCTFail("reverseGeocodingFailed error expected")
            return
        }

        guard case .generic(let code, let domain, let message) = reason as? SearchError else {
            XCTFail("Generic error expected")
            return
        }

        XCTAssertEqual(expectedError.code, code)
        XCTAssertEqual(expectedError.domain, domain)
        XCTAssertEqual(expectedError.localizedDescription, message)

        XCTAssertEqual(options.point, CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0))
    }

    func testQueryTypeConversions() {
        XCTAssertEqual(SearchQueryType.country.coreValue, .country)
        XCTAssertEqual(SearchQueryType.country.coreValue, .country)
        XCTAssertEqual(SearchQueryType.region.coreValue, .region)
        XCTAssertEqual(SearchQueryType.postcode.coreValue, .postcode)
        XCTAssertEqual(SearchQueryType.district.coreValue, .district)
        XCTAssertEqual(SearchQueryType.place.coreValue, .place)
        XCTAssertEqual(SearchQueryType.locality.coreValue, .locality)
        XCTAssertEqual(SearchQueryType.neighborhood.coreValue, .neighborhood)
        XCTAssertEqual(SearchQueryType.address.coreValue, .address)
        XCTAssertEqual(SearchQueryType.poi.coreValue, .poi)
    }

    func testQueryGetterSetter() {
        let searchEngine = SearchEngine(
            accessToken: "mapbox-access-token",
            serviceProvider: provider,
            locationProvider: DefaultLocationProvider()
        )

        XCTAssertEqual(searchEngine.query, "")

        searchEngine.query = "random-query"
        XCTAssertEqual(searchEngine.query, "random-query")
    }
}
