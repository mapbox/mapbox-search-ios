import XCTest
@testable import MapboxSearch
import CwlPreconditionTesting

class SearchResponseTests: XCTestCase {
    func testResolvedAddressResult() throws {
        let coreResponse = CoreSearchResponseStub(id: 377,
                                              options: .sample1,
                                                  result: .success([CoreSearchResultStub.makeAddress().asCoreSearchResult]))
        let response = SearchResponse(coreResponse: coreResponse)
        
        let processedResponse = try response.process().get()
        XCTAssertTrue(processedResponse.suggestions.count == 1)
        XCTAssertEqual(processedResponse.results.first?.coordinate, .sample1)
    }

    func testFailedResponse() throws {
        let failedCoreResponse = CoreSearchResponseStub.failureSample
        let response = SearchResponse(coreResponse: failedCoreResponse)
        XCTAssertThrowsError(try response.process().get()) { error in
            if case let .generic(code, domain, message) = error as? SearchError {
                XCTAssertEqual(code, 500)
                XCTAssertEqual(domain, mapboxCoreSearchErrorDomain)
                XCTAssertEqual(message, "Server Internal error")
            } else {
                XCTFail("Expected \(SearchError.self) error type")
            }
        }
    }
    
    func testSuccessResponseWithAssociatedError() throws {
        let nserror = NSError(domain: NSURLErrorDomain, code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])
        let coreResponse = CoreSearchResponseStub.failureSample(error: nserror)

        let response = SearchResponse(coreResponse: coreResponse)
        XCTAssertThrowsError(try response.process().get()) { error in
            if case let .generic(code, domain, message) = error as? SearchError {
                XCTAssertEqual(code, 400)
                XCTAssertEqual(domain, NSURLErrorDomain)
                XCTAssertEqual(message, nserror.localizedDescription)
            } else {
                XCTFail("Expected \(SearchError.self) error type")
            }
        }
    }

    func testSuccessResponseWithZeroResults() throws {
        let coreResponse = CoreSearchResponseStub(id: 377, options: .sample1, result: .success([]))
        let response = SearchResponse(coreResponse: coreResponse)
        
        let processedResponse = try response.process().get()
        XCTAssertTrue(processedResponse.suggestions.isEmpty)
    }
    
    func testSuccessResponseWithSuggestionsOnly() throws {
        let expectedResults = CoreSearchResultStub.makeSuggestionsSet().map { $0.asCoreSearchResult }
        let coreResponse = CoreSearchResponseStub(id: 377,
                                                  options: .sample1,
                                                  result: .success(expectedResults))
        let response = SearchResponse(coreResponse: coreResponse)
        
        let processedResponse = try response.process().get()
        XCTAssertTrue(processedResponse.results.isEmpty)
        XCTAssertEqual(processedResponse.suggestions.map({ $0.id }), expectedResults.map({ $0.id }))
    }
    
    func testSuccessResponseWithMixedResults() throws {
        let expectedResults = CoreSearchResultStub.makeMixedResultsSet().map { $0.asCoreSearchResult }
        let coreResponse = CoreSearchResponseStub(id: 377,
                                                  options: .sample1,
                                                  result: .success(expectedResults))
        let response = SearchResponse(coreResponse: coreResponse)
        
        let processedResponse = try response.process().get()
        XCTAssertEqual(processedResponse.results.map({ $0.id }), expectedResults.filter({ $0.center != nil }).map({ $0.id }) )
        XCTAssertEqual(processedResponse.suggestions.map({ $0.id }), expectedResults.map({ $0.id }))
    }
    
    func testSuccessResponseWithResultsOnly() throws {
        let expectedResults = CoreSearchResultStub.makeCategoryResultsSet().map { $0.asCoreSearchResult }
        let coreResponse = CoreSearchResponseStub(id: 377,
                                                  options: .sample1,
                                                  result: .success(expectedResults))
        let response = SearchResponse(coreResponse: coreResponse)
        
        let processedResponse = try response.process().get()
        XCTAssertEqual(processedResponse.results.map({ $0.id }), expectedResults.map({ $0.id }))
        XCTAssertEqual(processedResponse.suggestions.map({ $0.id }), expectedResults.map({ $0.id }))
    }
    
    func testSuccessResponseWithQueryOnly() throws {
        let expectedResults = [CoreSearchResultStub.makeSuggestionTypeQuery()].map { $0.asCoreSearchResult }
        let coreResponse = CoreSearchResponseStub(id: 377,
                                                  options: .sample1,
                                                  result: .success(expectedResults))
        let response = SearchResponse(coreResponse: coreResponse)
        
        let processedResponse = try response.process().get()
        XCTAssertEqual(processedResponse.suggestions.map({ $0.id }), expectedResults.map({ $0.id }))
    }
}
