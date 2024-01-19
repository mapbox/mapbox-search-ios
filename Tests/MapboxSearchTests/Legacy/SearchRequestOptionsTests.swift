import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchRequestOptionsTests: XCTestCase {
    func testInitCoordinatesTransformation() throws {
        let requestOptions = SearchRequestOptions(
            query: "test-query",
            proximity: CLLocationCoordinate2D(latitude: -10.45, longitude: 45.19)
        )

        XCTAssertEqual(requestOptions.query, "test-query")
        XCTAssertEqual(requestOptions.proximity, CLLocationCoordinate2D(latitude: -10.45, longitude: 45.19))
    }
}
