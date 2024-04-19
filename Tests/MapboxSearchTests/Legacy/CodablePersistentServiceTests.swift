import CoreLocation
@testable import MapboxSearch
import XCTest

class CodablePersistentServiceTests: XCTestCase {
    func testSaveCustomRecord() throws {
        let filename = "customRecord.test"
        let service = try XCTUnwrap(CodablePersistentService<TestRecord>(filename: filename))
        let record = TestRecord()
        XCTAssertTrue(service.saveData(record), "Unable to save record")
        if let loadedRecord = service.loadData() {
            XCTAssertEqual(record, loadedRecord)
        } else {
            XCTAssert(false, "Failed to init Service")
        }
        service.clear()
    }

    func testSaveFavoritesRecord() throws {
        let filename = "FavoritesRecord.test"
        let service = try XCTUnwrap(CodablePersistentService<FavoriteRecord>(filename: filename))
        let coordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let address = Address(
            houseNumber: "houseNumber",
            street: "street",
            neighborhood: "neighborhood",
            locality: "Locality",
            postcode: nil,
            place: "place",
            district: nil,
            region: "region",
            country: "None"
        )
        let record = FavoriteRecord(
            id: UUID().uuidString,
            name: "Say My Name",
            matchingName: nil,
            coordinate: coordinate,
            address: address,
            makiIcon: nil,
            serverIndex: nil,
            accuracy: nil,
            categories: [],
            resultType: .address(subtypes: [.address]),
            searchRequest: .init(query: "Sample", proximity: nil)
        )
        XCTAssertTrue(service.saveData(record), "Unable to save record")
        if let loadedRecord = service.loadData() {
            XCTAssertEqual(record, loadedRecord)
        } else {
            XCTAssert(false, "Failed to init Service")
        }
        service.clear()
    }

    func testSaveHistoryRecord() throws {
        let filename = "FavoritesRecord.test"
        let service = try XCTUnwrap(CodablePersistentService<HistoryRecord>(filename: filename))
        let coordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let record = HistoryRecord(
            id: UUID().uuidString,
            mapboxId: nil,
            name: "DaName",
            matchingName: nil,
            serverIndex: nil,
            accuracy: nil,
            coordinate: coordinate,
            timestamp: Date(),
            historyType: .category,
            type: .address(subtypes: [.address]),
            address: nil,
            searchRequest: .init(query: "Sample", proximity: nil)
        )
        XCTAssertTrue(service.saveData(record), "Unable to save record")
        if let loadedRecord = service.loadData() {
            XCTAssertEqual(record, loadedRecord)
        } else {
            XCTAssert(false, "Failed to init Service")
        }
        service.clear()
    }

    func testClean() throws {
        let filename = "customRecord.test"
        let service = try XCTUnwrap(CodablePersistentService<TestRecord>(filename: filename))
        let record = TestRecord()
        XCTAssertTrue(service.saveData(record), "Unable to save record")
        service.clear()
        XCTAssertNil(service.loadData(), "Data should be cleared")
    }
}

private struct TestRecord: Codable, Equatable {
    var iconName: String?
    var id: String
    var name: String
    var coordinate: CLLocationCoordinate2DCodable

    var address: TestAddress
    var icon: Maki?
    var categories: [String]?

    init() {
        self.iconName = "Some Icon"
        self.id = UUID().uuidString
        self.name = "Test Record"
        self.coordinate = CLLocationCoordinate2DCodable(latitude: 10.0, longitude: 10.0)
        self.address = TestAddress()
        self.categories = ["One", "Two", "Three"]
    }
}

private struct TestAddress: Codable, Equatable {
    var houseNumber: String? = "houseNumber"
    var street: String? = "street"
    var neighborhood: String? = "neighborhood"
    var locality: String? = "locality"
}
