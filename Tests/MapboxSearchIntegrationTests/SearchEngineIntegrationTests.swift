import XCTest
import CoreLocation
@testable import MapboxSearch

class SearchEngineIntegrationTests: MockServerTestCase {
    
    let delegate = SearchEngineDelegateStub()
    lazy var searchEngine = SearchEngine(
        accessToken: "access-token",
        locationProvider: DefaultLocationProvider(),
        supportSBS: true
    )
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        searchEngine.delegate = delegate
    }
    
    func testNotFoundSearch() throws {
        // No server response set, 404 error should be received
        let expectation = delegate.errorExpectation
        searchEngine.search(query: "some query")
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(delegate.error?.errorCode == 404)
        XCTAssert(searchEngine.suggestions.isEmpty)
    }
    
    func testSearchBrokenResponse() throws {
        server.setResponse(endpoint: .suggest, body: "This is so sad!", statusCode: 200)
        let expectation = delegate.errorExpectation
        searchEngine.search(query: "some query")
        wait(for: [expectation], timeout: 10)
                
        if case .internalSearchRequestError(let message) = delegate.error {
            XCTAssert(message == "Invalid json response")
        } else {
            XCTFail("Not expected")
        }
        
        XCTAssert(searchEngine.suggestions.isEmpty)
    }
    
    func testSimpleSearch() throws {
        
        try server.setResponse(.suggestMinsk)
        
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(searchEngine.suggestions.contains { $0.name == "Minsk" })
    }
    
    func testSimpleSearchFailed() throws {
        
        try server.setResponse(.suggestMinsk, statusCode: 500)
        
        let expectation = delegate.errorExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(searchEngine.suggestions.isEmpty)
        XCTAssert(delegate.error?.errorCode == 500)
    }
    
    func testEmptySearch() throws {

        try server.setResponse(.suggestEmpty)
        
        let expectation = delegate.updateExpectation
        searchEngine.search(query: "Minsk")
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(searchEngine.suggestions.isEmpty)
        XCTAssertNil(delegate.error)
    }
    
    func testReverseGeocodingSearch() throws {
        
        try server.setResponse(.reverseGeocoding)
        
        let expectation = XCTestExpectation()
        let options = ReverseGeocodingOptions(point: CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0))
        searchEngine.reverseGeocoding(options: options) { result in
            if case .success(let reverseGeocodingResults) = result {
                XCTAssertFalse(reverseGeocodingResults.isEmpty)
            } else {
                XCTFail("No resolved result")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testReverseGeocodingSearchFailed() throws {
        
        try server.setResponse(.reverseGeocoding, statusCode: 500)
        
        let expectation = XCTestExpectation()
        let options = ReverseGeocodingOptions(point: CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0))
        searchEngine.reverseGeocoding(options: options) { result in
            if case .failure(let error) = result {
                if case .reverseGeocodingFailed(let reasonError as NSError, _) = error {
                    XCTAssert(reasonError.code == 500)
                } else {
                    XCTFail("Not expected")
                }
            } else {
                XCTFail("Not expected")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testResolvedSearchResult() throws {
        
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk)
        
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        
        let successExpectation = delegate.successExpectation
        let selectedResult = searchEngine.suggestions.first!
        searchEngine.select(suggestion: selectedResult)
        wait(for: [successExpectation], timeout: 10)
        let resolvedResult = try XCTUnwrap(delegate.resolvedResult)
        
        XCTAssertEqual(resolvedResult.name, selectedResult.name)
    }
    
    func testResolvedSearchResultFailed() throws {
        
        try server.setResponse(.suggestMinsk)
        try server.setResponse(.retrieveMinsk, statusCode: 500)
        
        let updateExpectation = delegate.updateExpectation
        searchEngine.search(query: "sample-1")
        wait(for: [updateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
        
        let errorExpectation = delegate.errorExpectation
        let selectedResult = searchEngine.suggestions.first!
        searchEngine.select(suggestion: selectedResult)
        wait(for: [errorExpectation], timeout: 10)
        
        if case .resultResolutionFailed(let suggestion) = delegate.error {
            XCTAssertEqual(selectedResult.id, suggestion.id)
            XCTAssertEqual(selectedResult.name, suggestion.name)
            XCTAssertEqual(selectedResult.address, suggestion.address)
        } else {
            XCTFail("Not expected")
        }
        
        XCTAssertNil(delegate.resolvedResult)
    }
    
    func testBatchResolve() throws {
        
        try server.setResponse(.multiRetrieve)
        
        let results = CoreSearchResultStub.makeMixedResultsSet().map { $0.asCoreSearchResult }
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        
        let suggestions = CoreSearchResultStub.makeSuggestionsSet().map({ $0.asCoreSearchResult }).compactMap {
            SearchResultSuggestionImpl(coreResult: $0, response: coreResponse)
        }
        
        let expectation = delegate.batchUpdateExpectation
        searchEngine.select(suggestions: suggestions)
        
        wait(for: [expectation], timeout: 10)
        XCTAssertFalse(delegate.resolvedResults.isEmpty)
    }
    
    func testBatchResolveFailed() throws {
        
        try server.setResponse(.multiRetrieve, statusCode: 500)
        
        let results = CoreSearchResultStub.makeMixedResultsSet().map { $0.asCoreSearchResult }
        let coreResponse = CoreSearchResponseStub.successSample(results: results)
        
        let suggestions = CoreSearchResultStub.makeSuggestionsSet().map({ $0.asCoreSearchResult }).compactMap {
            SearchResultSuggestionImpl(coreResult: $0, response: coreResponse)
        }
        
        let expectation = delegate.errorExpectation
        searchEngine.select(suggestions: suggestions)
        
        wait(for: [expectation], timeout: 10)
        XCTAssert(delegate.error?.errorCode == 500)
    }
    
    func testSuggestionTypeQuery() throws {
        
        try server.setResponse(.recursion)
        
        let updateExpectation = delegate.updateExpectation
        searchEngine.query = "Recursion"
        wait(for: [updateExpectation], timeout: 10)
        
        searchEngine.select(suggestion: searchEngine.suggestions.first!)
        
        let nextUpdateExpectation = delegate.updateExpectation
        wait(for: [nextUpdateExpectation], timeout: 10)
        XCTAssertFalse(searchEngine.suggestions.isEmpty)
    }
}
