import CoreLocation
@testable import MapboxSearch
import XCTest

class CoreBoundingBoxTests: XCTestCase {
    func testExample() throws {
        let southWest = CLLocationCoordinate2D(latitude: 12, longitude: 23)
        let northEast = CLLocationCoordinate2D(latitude: 34, longitude: 45)
        let bbox = BoundingBox(southWest, northEast)
        let coreBBox = CoreBoundingBox(boundingBox: bbox)

        XCTAssertEqual(coreBBox.min, southWest)
        XCTAssertEqual(coreBBox.max, northEast)
    }
}
