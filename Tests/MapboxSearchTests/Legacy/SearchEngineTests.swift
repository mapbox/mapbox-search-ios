import CoreLocation
import CwlPreconditionTesting
@testable import MapboxSearch
import XCTest

class SearchEngineTests: XCTestCase {
    var delegate: SearchEngineDelegateStub!
    var provider: ServiceProviderStub!
    var locationProvider: DefaultLocationProvider!
    let accessToken = "mapbox-access-token"
    let timeout: TimeInterval = 0.5

    override func setUp() {
        super.setUp()

        locationProvider = DefaultLocationProvider()
        delegate = SearchEngineDelegateStub()
        provider = ServiceProviderStub()
        provider.localHistoryProvider.clearData()
        provider.localFavoritesProvider.clearData()
    }

    override func tearDown() {
        provider = nil

        super.tearDown()
    }

    func makeSearchEngine(with apiType: ApiType = .searchBox) -> SearchEngine {
        let searchEngine = SearchEngine(
            accessToken: accessToken,
            serviceProvider: provider,
            locationProvider: locationProvider,
            apiType: apiType
        )
        searchEngine.delegate = delegate
        return searchEngine
    }

    func testEmptySearch() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)

        let coreResponse = CoreSearchResponseStub.successSample(results: [])
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: CoreRequestOptions.sampleQuery1)
        wait(for: [expectation], timeout: timeout)

        guard case .success(let result) = response.process() else {
            XCTFail("impossible")
            return
        }
        XCTAssertTrue(result.suggestions.isEmpty)
        XCTAssertTrue(result.results.isEmpty)
        XCTAssertTrue(searchEngine.suggestions.isEmpty)
    }

    func testMixedSearch() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let expectation = delegate.updateExpectation
        searchEngine.search(query: CoreRequestOptions.sampleQuery1)
        wait(for: [expectation], timeout: timeout)

        guard case .success(let result) = response.process() else {
            XCTFail("impossible")
            return
        }
        XCTAssertEqual(result.suggestions.map(\.id), results.map(\.id))
        XCTAssertEqual(result.suggestions.map(\.id), searchEngine.suggestions.map(\.id))
    }

    func testReverseGeocodingSearch() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        engine.searchResponse = coreResponse
        let expectation = XCTestExpectation()
        let point = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)

        searchEngine.reverse(options: .init(point: point)) { result in
            if case .success(let reverseGeocodingResults) = result {
                XCTAssertEqual(reverseGeocodingResults.map(\.id), results.map(\.id))
            } else {
                XCTFail("impossible")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testErrorSearch() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let coreResponse = CoreSearchResponseStub.failureSample
        engine.searchResponse = coreResponse
        let expectation = delegate.errorExpectation
        searchEngine.search(query: coreResponse.request.query)
        wait(for: [expectation], timeout: timeout)

        XCTAssertTrue(searchEngine.suggestions.isEmpty)
    }

    func testIgnoreResultsForOutdatedSearchQuery() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let mockedResults = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(options: .sample1, results: mockedResults)
        engine.searchResponse = coreResponse
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: CoreRequestOptions.sampleQuery1)
        wait(for: [updateExpectation], timeout: timeout)

        XCTAssertEqual(searchEngine.suggestions.map(\.id), mockedResults.map(\.id))

        engine.searchResponse = CoreSearchResponseStub.successSample(options: .sample2, results: [])

        let expectations = [delegate.updateExpectation, delegate.successExpectation, delegate.errorExpectation]
        expectations.forEach { $0.isInverted = true }
        searchEngine.search(query: "new_query")
        wait(for: expectations, timeout: timeout)

        XCTAssertEqual(searchEngine.suggestions.map(\.id), mockedResults.map(\.id))
    }

    func testIgnoreErrorForOutdatedSearchQuery() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let mockedResults = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: mockedResults)
        engine.searchResponse = coreResponse
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: CoreRequestOptions.sampleQuery1)
        wait(for: [updateExpectation], timeout: timeout)

        XCTAssertEqual(searchEngine.suggestions.map(\.id), mockedResults.map(\.id))

        engine.searchResponse = CoreSearchResponseStub.failureSample
        let expectations = [delegate.updateExpectation, delegate.successExpectation, delegate.errorExpectation]
        expectations.forEach { $0.isInverted = true }
        searchEngine.search(query: "new_query")
        wait(for: expectations, timeout: timeout)

        XCTAssertEqual(searchEngine.suggestions.map(\.id), mockedResults.map(\.id))
    }

    func testResolvedSearchResult() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let mockedResults = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: mockedResults)
        engine.searchResponse = coreResponse

        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: CoreRequestOptions.sampleQuery1)
        wait(for: [updateExpectation], timeout: timeout)
        XCTAssertEqual(searchEngine.suggestions.map(\.id), mockedResults.map(\.id))

        let successExpectation = delegate.successExpectation
        let selectedResult = searchEngine.suggestions.first!
        searchEngine.select(suggestion: selectedResult)
        wait(for: [successExpectation], timeout: timeout)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)

        XCTAssertEqual(resolvedResult.id, selectedResult.id)
    }

    func testDataLayerProvider() throws {
        let searchEngine = makeSearchEngine()
        let mockedResults = CoreSearchResultStub.makeMixedResultsSet()
        mockedResults.forEach { $0.customDataLayerIdentifier = DataLayerProviderStub.providerIdentifier }
        let records = [IndexableRecordStub(), IndexableRecordStub(), IndexableRecordStub()]
        let dataLayerProvider = DataLayerProviderStub(records: records)

        let serviceProvider = provider!
        serviceProvider.dataLayerProviders.append(dataLayerProvider)

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let coreResponse = CoreSearchResponseStub.successSample(results: mockedResults)
        engine.searchResponse = coreResponse
        let response = SearchResponse(coreResponse: coreResponse)
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: CoreRequestOptions.sampleQuery1)
        wait(for: [updateExpectation], timeout: timeout)
        if case .success(let result) = response.process() {
            XCTAssertEqual(result.suggestions.map(\.id), mockedResults.map(\.id))
            XCTAssertEqual(searchEngine.suggestions.map(\.id), mockedResults.map(\.id))
        } else {
            XCTFail("impossible")
        }

        let successExpectation = delegate.successExpectation
        let selectedResult = searchEngine.suggestions.first!
        searchEngine.select(suggestion: selectedResult)
        wait(for: [successExpectation], timeout: timeout)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)

        XCTAssertEqual(resolvedResult.id, selectedResult.id)
    }

    func testBatchResolve() throws {
        let searchEngine = makeSearchEngine(with: .geocoding)

        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let mockedResults = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: mockedResults)
        engine.searchResponse = coreResponse
        let expectation = delegate.batchUpdateExpectation

        let suggestions = CoreSearchResultStub.makeSuggestionsSet().compactMap {
            SearchResultSuggestionImpl(coreResult: $0, response: coreResponse)
        }

        searchEngine.select(suggestions: suggestions)

        wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(delegate.resolvedResults.map(\.id), mockedResults.map(\.id))
    }

    func testEmptyBatchResolve() throws {
        let searchEngine = makeSearchEngine(with: .geocoding)
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let mockedResults = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: mockedResults)
        engine.searchResponse = coreResponse
        let expectation = delegate.batchUpdateExpectation
        expectation.isInverted = true
        let suggestions: [SearchSuggestion] = []

        searchEngine.select(suggestions: suggestions)
        wait(for: [expectation], timeout: timeout)
        XCTAssertTrue(delegate.resolvedResults.isEmpty)
    }

    func testSuggestionTypeQuery() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let expectedResults = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: expectedResults)
        engine.searchResponse = coreResponse

        let updateExpectation = delegate.updateExpectation

        let coreSuggestion = CoreSearchResultStub.makeSuggestionTypeQuery()
        coreSuggestion.centerLocation = nil
        let suggestion = try XCTUnwrap(SearchResultSuggestionImpl(coreResult: coreSuggestion, response: coreResponse))
        searchEngine.query = CoreRequestOptions.sampleQuery1
        searchEngine.select(suggestion: suggestion)

        wait(for: [updateExpectation], timeout: timeout)
        let results = searchEngine.suggestions

        XCTAssertEqual(results.map(\.id), expectedResults.map(\.id))
    }

    func testBatchResolveFailedResponse() throws {
        let searchEngine = makeSearchEngine(with: .geocoding)
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

        wait(for: [expectation], timeout: timeout)

        guard case .generic(let code, let domain, let message) = delegate.error else {
            XCTFail("Generic error expected")
            return
        }
        XCTAssertEqual(code, expectedError.code)
        XCTAssertEqual(domain, expectedError.domain)
        XCTAssertEqual(message, expectedError.localizedDescription)
    }

    func testBatchResolveNoResponse() throws {
        let searchEngine = makeSearchEngine(with: .geocoding)
        let expectation = delegate.errorExpectation

        let results = CoreSearchResultStub.makeMixedResultsSet()
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        let suggestions = CoreSearchResultStub.makeSuggestionsSet().compactMap {
            SearchResultSuggestionImpl(coreResult: $0, response: coreResponse)
        }
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        engine.callbackWrapper = { [weak self] callback in
            guard let self else { return }
            let assertionError = catchBadInstruction {
                callback()
            }
            XCTAssertNil(assertionError)

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

            wait(for: [expectation], timeout: timeout)

            let expectedError = SearchError.responseProcessingFailed
            XCTAssertEqual(delegate.error, expectedError)
        }
    }

    func testReverseGeocodingNoResponse() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        engine.callbackWrapper = { [weak self] callback in
            guard let self else { return }
            let assertionError = catchBadInstruction {
                callback()
            }
            XCTAssertNil(assertionError)

            let expectation = XCTestExpectation()
            var error: SearchError?
            let point = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)
            searchEngine.reverse(options: .init(point: point)) { result in
                if case .failure(let searchError) = result {
                    error = searchError
                } else {
                    XCTFail("impossible")
                }
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: timeout)

            XCTAssertEqual(error, SearchError.responseProcessingFailed)
        }
    }

    func testReverseGeocodingFailedResponse() throws {
        let searchEngine = makeSearchEngine()
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
        searchEngine.reverse(options: .init(point: point)) { result in
            if case .failure(let searchError) = result {
                error = searchError
            } else {
                XCTFail("Unexpected")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeout)

        guard case .reverseGeocodingFailed(let reason, let options) = error else {
            XCTFail("reverseGeocodingFailed error expected")
            return
        }

        guard case .generic(let code, let domain, let message) = reason as? SearchError else {
            XCTFail("Generic error expected")
            return
        }

        XCTAssertEqual(code, expectedError.code)
        XCTAssertEqual(domain, expectedError.domain)
        XCTAssertEqual(message, expectedError.localizedDescription)

        XCTAssertEqual(options.point, CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0))
    }

    func testQueryGetterSetter() {
        let searchEngine = makeSearchEngine()
        XCTAssertEqual(searchEngine.query, "")

        searchEngine.query = "random-query"
        XCTAssertEqual(searchEngine.query, "random-query")

        searchEngine.search(query: "another-query")
        XCTAssertEqual(searchEngine.query, "another-query")
    }

    func testSelectSuggestionWithRetrieveOptions() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)

        let mockedResults = CoreSearchResultStub.makeSuggestionsSet()
        let coreResponse = CoreSearchResponseStub.successSample(options: .sample1, results: mockedResults)
        engine.searchResponse = coreResponse

        let searchOptions = SearchOptions(
            limit: 100,
            origin: CLLocationCoordinate2D(latitude: 38.902309, longitude: -77.029129),
            filterQueryTypes: [.poi]
        )
        searchEngine.search(query: CoreRequestOptions.sampleQuery1, options: searchOptions)
        wait(for: [delegate.updateExpectation], timeout: timeout)

        guard let suggestion = searchEngine.suggestions.first else {
            XCTFail("No suggestions found")
            return
        }

        let mockedResult = CoreSearchResultStub.makeAddress()
        mockedResult.metadata = CoreResultMetadata.make(data: ["a": "b"])
        let retrieveCoreResponse = CoreSearchResponseStub.successSample(
            options: .sample1, results: [mockedResult]
        )
        engine.nextSearchResponse = retrieveCoreResponse

        let retrieveOptions = RetrieveOptions(attributeSets: [.basic, .venue])
        searchEngine.select(suggestion: suggestion, options: retrieveOptions)
        wait(for: [delegate.successExpectation], timeout: timeout)

        let expectedOptions = retrieveOptions.toCore()
        XCTAssertTrue(engine.nextSearchCalled)
        XCTAssertEqual(engine.passedCoreRetrieveOptions?.attributeSets, expectedOptions.attributeSets)
        let resolvedResult = delegate.resolvedResult
        XCTAssertEqual(resolvedResult?.id, mockedResult.id)
        XCTAssertEqual(resolvedResult?.metadata?.data, mockedResult.metadata?.data)
    }

    func testServerSearchResultByBrandType() throws {
        let searchEngine = makeSearchEngine()
        let engine = try XCTUnwrap(searchEngine.engine as? CoreSearchEngineStub)
        let updateExpectation = delegate.updateExpectation

        let expectedBrand = CoreSearchResultStub.makeBrand()
        let mockedResults = [expectedBrand, CoreSearchResultStub.makePlace()]
        let coreResponse = CoreSearchResponseStub.successSample(options: .sample1, results: mockedResults)
        engine.searchResponse = coreResponse

        let brandFilterOptions = SearchOptions()
        searchEngine.search(query: CoreRequestOptions.sampleQuery1, options: brandFilterOptions)
        wait(for: [updateExpectation], timeout: timeout)

        let suggestions = searchEngine.suggestions
        XCTAssertEqual(suggestions.count, 2)
        let suggestionWithBrandID = suggestions.first!
        XCTAssertEqual(suggestionWithBrandID.brand, expectedBrand.brand)
        XCTAssertEqual(suggestionWithBrandID.brandID, expectedBrand.brandID)
        XCTAssertEqual(suggestionWithBrandID.id, expectedBrand.id)
        XCTAssertEqual(suggestionWithBrandID.mapboxId, expectedBrand.mapboxId)
        XCTAssertEqual(suggestionWithBrandID.suggestionType, .brand)

        XCTAssertEqual(suggestions[1].suggestionType, .address(subtypes: [.place]))
    }
}
