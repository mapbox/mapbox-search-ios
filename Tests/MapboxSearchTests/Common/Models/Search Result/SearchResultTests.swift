@testable import MapboxSearch
import XCTest

class SearchResultTests: XCTestCase {
    func testPlacemarkGeneration() throws {
        let resultStub = SearchResultStub(
            id: "unit-test-random",
            mapboxId: nil,
            name: "Unit Test",
            matchingName: nil,
            serverIndex: nil,
            resultType: .POI,
            coordinate: .init(latitude: 12, longitude: -35),
            distance: nil,
            metadata: .pizzaMetadata
        )

        XCTAssertEqual(resultStub.placemark.location?.coordinate.latitude, 12)
        XCTAssertEqual(resultStub.placemark.location?.coordinate.longitude, -35)
    }

    func testCategories() throws {
        let expectedCategories = ["category1", "category2"]
        let resultStub = SearchResultStub(
            id: "unit-test-random",
            mapboxId: nil,
            categories: expectedCategories,
            name: "Unit Test",
            matchingName: nil,
            serverIndex: nil,
            resultType: .POI,
            coordinate: .init(latitude: 12, longitude: -35),
            distance: nil,
            metadata: .pizzaMetadata
        )

        XCTAssertEqual(resultStub.categories, expectedCategories)
    }

    func testCategoryIds() throws {
        let expectedCategoryIds = ["categoryID1", "categoryID2"]
        let resultStub = SearchResultStub(
            id: "unit-test-random",
            mapboxId: nil,
            categoryIds: expectedCategoryIds,
            name: "Unit Test",
            matchingName: nil,
            serverIndex: nil,
            resultType: .POI,
            coordinate: .init(latitude: 12, longitude: -35),
            distance: nil,
            metadata: .pizzaMetadata
        )

        XCTAssertEqual(resultStub.categoryIds, expectedCategoryIds)
    }
}
