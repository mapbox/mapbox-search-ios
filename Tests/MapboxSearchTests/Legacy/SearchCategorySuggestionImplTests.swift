import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchCategorySuggestionImplTests: XCTestCase {
    func testSuccessfulInit() throws {
        let coreResult = CoreSearchResultStub(
            id: "sample-2",
            mapboxId: "sample-2",
            type: .category,
            namePreferred: "Preferred name",
            centerLocation: nil,
            categories: ["cat-1"],
            categoryIDs: ["cat-ID-1"],
            icon: Maki.soccer.name
        )
        let suggestionImpl = try XCTUnwrap(SearchCategorySuggestionImpl(
            coreResult: coreResult,
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
        XCTAssertEqual(suggestionImpl.suggestionType, .category)
        XCTAssertEqual(suggestionImpl.name, coreResult.names.first)
        XCTAssertEqual(suggestionImpl.namePreferred, "Preferred name")
        XCTAssertEqual(suggestionImpl.categories, ["cat-1"])
        XCTAssertEqual(suggestionImpl.categoryIds, ["cat-ID-1"])
        XCTAssertEqual(suggestionImpl.iconName, Maki.soccer.name)
    }

    func testFailedInitForPOI() throws {
        XCTAssertNil(SearchCategorySuggestionImpl(
            coreResult: CoreSearchResultStub(
                id: "sample-1",
                mapboxId: "",
                type: .poi,
                centerLocation: nil
            ),
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
    }
}
