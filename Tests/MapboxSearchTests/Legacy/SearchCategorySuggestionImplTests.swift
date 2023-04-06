import XCTest
@testable import MapboxSearch
import CoreLocation

class SearchCategorySuggestionImplTests: XCTestCase {
    func testSuccessfulInit() throws {
        let suggestionImpl = try XCTUnwrap(SearchCategorySuggestionImpl(coreResult: CoreSearchResultStub(id: "sample-2",
                                                                                                         type: .category,
                                                                                                         center: nil),
                                                                        response: CoreSearchResponseStub(id: 42,
                                                                                                         options: .sample1,
                                                                                                         result: .success([]))))
        XCTAssertEqual(suggestionImpl.suggestionType, .category)
    }
    
    func testFailedInitForPOI() throws {
        XCTAssertNil(SearchCategorySuggestionImpl(coreResult: CoreSearchResultStub(id: "sample-1", type: .poi, center: nil),
                                                  response: CoreSearchResponseStub(id: 42,
                                                                                   options: .sample1,
                                                                                   result: .success([]))))
    }

    func testSuccessfulInitWithCanonicalCategoryName() throws {
        let response = CoreSearchResponseStub(id: 42,
                                              options: .sample1,
                                              result: .success([]))
        let coreResult1 = CoreSearchResultStub(id: "sample-2",
                                               type: .category,
                                               center: nil,
                                               externalIds: ["federated": "category.sushi_restaurant"])
        let suggestionImpl1 = try XCTUnwrap(SearchCategorySuggestionImpl(coreResult: coreResult1, response: response))
        XCTAssertEqual(suggestionImpl1.categoryCanonicalName, "sushi_restaurant")

        let coreResult2 = CoreSearchResultStub(id: "sample-2",
                                               type: .category,
                                               center: nil,
                                               externalIds: ["federated": "incorrect_prefix.cafe"])
        let suggestionImpl2 = try XCTUnwrap(SearchCategorySuggestionImpl(coreResult: coreResult2, response: response))
        XCTAssertNil(suggestionImpl2.categoryCanonicalName)

        let coreResult3 = CoreSearchResultStub(id: "sample-2",
                                               type: .category,
                                               center: nil,
                                               externalIds: ["a": "b"])
        let suggestionImpl3 = try XCTUnwrap(SearchCategorySuggestionImpl(coreResult: coreResult3, response: response))
        XCTAssertNil(suggestionImpl2.categoryCanonicalName)
    }
}
