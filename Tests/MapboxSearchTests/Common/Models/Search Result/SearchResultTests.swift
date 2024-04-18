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
            metadata: .pizzaMetadata
        )

        XCTAssertEqual(resultStub.placemark.location?.coordinate.latitude, 12)
        XCTAssertEqual(resultStub.placemark.location?.coordinate.longitude, -35)
    }
}
