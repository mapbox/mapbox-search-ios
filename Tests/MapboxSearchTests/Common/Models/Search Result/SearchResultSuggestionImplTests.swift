import CoreLocation
import CwlPreconditionTesting
@testable import MapboxSearch
import XCTest

class SearchResultSuggestionImplTests: XCTestCase {
    func testSuccessfulInitForAddressType() throws {
        let coreResult = CoreSearchResultStub(
            id: "sample-2",
            mapboxId: "sample-2",
            type: .address,
            namePreferred: "Preferred name",
            centerLocation: nil
        )
        let suggestionImpl = try XCTUnwrap(SearchResultSuggestionImpl(
            coreResult: coreResult,
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
        XCTAssertEqual(suggestionImpl.suggestionType, .address(subtypes: [.address]))
        XCTAssertEqual(suggestionImpl.name, coreResult.names.first)
        XCTAssertEqual(suggestionImpl.namePreferred, "Preferred name")
    }

    func testSuccessfulInitForPOIType() throws {
        let coreResult = CoreSearchResultStub(
            id: "sample-2",
            mapboxId: "sample-2",
            type: .poi,
            namePreferred: "Preferred name",
            centerLocation: nil
        )
        let suggestionImpl = try XCTUnwrap(SearchResultSuggestionImpl(
            coreResult: coreResult,
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
        XCTAssertEqual(suggestionImpl.suggestionType, .POI)
        XCTAssertEqual(suggestionImpl.name, coreResult.names.first)
        XCTAssertEqual(suggestionImpl.namePreferred, coreResult.namePreferred)
    }

    func testSuccessfulInitForCategories() throws {
        let coreResult = CoreSearchResultStub(
            id: "sample-2",
            mapboxId: "sample-2",
            type: .poi,
            centerLocation: nil,
            categories: ["category1", "category2"]
        )
        let suggestionImpl = try XCTUnwrap(SearchResultSuggestionImpl(
            coreResult: coreResult,
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
        XCTAssertEqual(suggestionImpl.suggestionType, .POI)
        XCTAssertEqual(suggestionImpl.name, coreResult.names.first)
        XCTAssertEqual(suggestionImpl.categories, coreResult.categories)
    }

    func testSuccessfulInitForCategoryIds() throws {
        let coreResult = CoreSearchResultStub(
            id: "sample-2",
            mapboxId: "sample-2",
            type: .poi,
            centerLocation: nil,
            categoryIDs: ["categoryID1", "categoryID2"]
        )
        let suggestionImpl = try XCTUnwrap(SearchResultSuggestionImpl(
            coreResult: coreResult,
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
        XCTAssertEqual(suggestionImpl.suggestionType, .POI)
        XCTAssertEqual(suggestionImpl.name, coreResult.names.first)
        XCTAssertEqual(suggestionImpl.categoryIds, coreResult.categoryIDs)
    }

    func testFailedInit() throws {
        XCTAssertNil(SearchResultSuggestionImpl(
            coreResult: CoreSearchResultStub(
                id: "sample-2",
                mapboxId: "sample-2",
                type: .category,
                centerLocation: nil
            ),
            response: CoreSearchResponseStub(
                id: 42,
                options: .sample1,
                result: .success([])
            )
        ))
    }

    func testMore() throws {
        let exception = catchBadInstruction {
            _ = SearchResultSuggestionImpl(
                coreResult: CoreSearchResultStub(
                    id: "sample-2",
                    mapboxId: "sample-2",
                    type: .category,
                    centerLocation: .sample1
                ),
                response: CoreSearchResponseStub(
                    id: 42,
                    options: .sample1,
                    result: .success([])
                )
            )
        }

        XCTAssertNotNil(exception)
    }
}
