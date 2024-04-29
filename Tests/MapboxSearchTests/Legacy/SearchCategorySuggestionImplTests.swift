import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchCategorySuggestionImplTests: XCTestCase {
    func testSuccessfulInit() throws {
        let suggestionImpl = try XCTUnwrap(SearchCategorySuggestionImpl(
            coreResult: CoreSearchResultStub(
                id: "sample-2",
                mapboxId: nil,
                type: .category,
                center: nil
            ),
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
        XCTAssertEqual(suggestionImpl.suggestionType, .category)
    }

    func testFailedInitForPOI() throws {
        XCTAssertNil(SearchCategorySuggestionImpl(
            coreResult: CoreSearchResultStub(id: "sample-1", mapboxId: nil, type: .poi, center: nil),
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
    }
}
