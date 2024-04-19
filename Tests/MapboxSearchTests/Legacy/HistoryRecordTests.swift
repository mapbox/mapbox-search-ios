@testable import MapboxSearch
import XCTest

class HistoryRecordTests: XCTestCase {
    func testHistoryRecordCategories() throws {
        let record = HistoryRecord(
            id: UUID().uuidString,
            mapboxId: nil,
            name: "DaName",
            matchingName: nil,
            serverIndex: nil,
            accuracy: nil,
            coordinate: .sample1,
            timestamp: Date(),
            historyType: .category,
            type: .address(subtypes: [.address]),
            address: nil,
            searchRequest: .init(query: "Sample", proximity: nil)
        )
        XCTAssertNil(record.categories)
    }

    func testHistoryRecordCoordinates() {
        var record = HistoryRecord(
            id: UUID().uuidString,
            mapboxId: nil,
            name: "DaName",
            matchingName: nil,
            serverIndex: nil,
            accuracy: nil,
            coordinate: .sample1,
            timestamp: Date(),
            historyType: .category,
            type: .address(subtypes: [.address]),
            address: nil,
            searchRequest: .init(query: "Sample", proximity: nil)
        )

        XCTAssertEqual(record.coordinate, .sample1)

        record.coordinate = .sample2
        XCTAssertEqual(record.coordinate, .sample2)
    }

    func testHistoryRecordDescriptionText() {
        let record = HistoryRecord(
            id: UUID().uuidString,
            mapboxId: nil,
            name: "DaName",
            matchingName: nil,
            serverIndex: nil,
            accuracy: nil,
            coordinate: .sample1,
            timestamp: Date(),
            historyType: .category,
            type: .address(subtypes: [.address]),
            address: .mapboxDCOffice,
            searchRequest: .init(query: "Sample", proximity: nil)
        )

        XCTAssertEqual(record.descriptionText, "740 15th St NW, Washington")
    }

    func testHistoryRecordInitFromSearchResult() {
        let timestamp = Date(timeIntervalSince1970: 18473536)
        let result = SearchResultStub.sample1
        let record = HistoryRecord(searchResult: result, timestamp: timestamp)

        XCTAssertEqual(record.name, result.name)

        XCTAssertEqual(record.id, result.id)
        XCTAssertEqual(record.name, result.name)
        XCTAssertEqual(record.coordinate, result.coordinate)
        XCTAssertEqual(record.timestamp, timestamp)
        XCTAssertEqual(record.historyType, .result)
        XCTAssertEqual(record.type, result.type)
        XCTAssertEqual(record.address, result.address)
        XCTAssertEqual(record.metadata, result.metadata)
        XCTAssertEqual(record.routablePoints, result.routablePoints)
    }
}
