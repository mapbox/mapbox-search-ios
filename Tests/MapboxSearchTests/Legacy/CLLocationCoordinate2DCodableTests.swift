@testable import MapboxSearch
import XCTest

class CLLocationCoordinate2DCodableTests: XCTestCase {
    func testExample() throws {
        var coordinate = CLLocationCoordinate2DCodable(latitude: 86, longitude: -45)
        coordinate.coordinates.latitude = 86.97
        coordinate.coordinates.longitude = -45.42

        XCTAssertEqual(coordinate.coordinates.latitude, 86.97)
        XCTAssertEqual(coordinate.coordinates.longitude, -45.42)
    }
}
