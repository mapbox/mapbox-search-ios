@testable import MapboxSearch
import XCTest

class FavoriteRecordTests: XCTestCase {
    func testInitWithSearchResult() {
        let resultStub = SearchResultStub.sample1
        let record = FavoriteRecord(id: "unique-id", name: "Custom Name", searchResult: resultStub)

        XCTAssertEqual(record.id, "unique-id")
        XCTAssertEqual(record.name, "Custom Name")
        XCTAssertEqual(record.address, resultStub.address)
        XCTAssertEqual(record.categories, resultStub.categories)
        XCTAssertEqual(record.coordinateCodable, resultStub.coordinateCodable)
        XCTAssertEqual(record.coordinate, resultStub.coordinate)
        XCTAssertEqual(record.icon, .bar)
        XCTAssertEqual(record.type, resultStub.type)

        XCTAssertNil(record.additionalTokens)
    }

    func testSettingCoordinates() {
        var record = FavoriteRecord(name: "Custom Name", searchResult: SearchResultStub.sample1)

        XCTAssertEqual(record.coordinate, .sample1)

        record.coordinate = .sample2
        XCTAssertEqual(record.coordinate, .sample2)
    }

    func testDescriptionText() {
        let record = FavoriteRecord(name: "Custom Name", searchResult: SearchResultStub.sample1)

        XCTAssertNotNil(record.address)
        XCTAssertNotNil(record.descriptionText)
        XCTAssertEqual(record.descriptionText, record.address?.formattedAddress(style: .medium))
    }
}
