import CoreLocation
@testable import MapboxSearch
import XCTest

class BoundingBoxTests: XCTestCase {
    func testContainsCoordinate() {
        let bottomleft = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let topRight = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)
        let coordinate = CLLocationCoordinate2D(latitude: 11.0, longitude: 11.0)
        let box = BoundingBox(bottomleft, topRight)
        XCTAssertTrue(box.contains(coordinate))
    }

    func testContainsCoordinateOnBorders() {
        let box = BoundingBox(.sample1, .sample2)

        XCTAssertFalse(box.contains(.sample1, ignoreBoundary: true))
        XCTAssertTrue(box.contains(.sample1, ignoreBoundary: false))
    }

    func testNotContainsCoordinate() {
        let bottomleft = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let topRight = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)
        let coordinate = CLLocationCoordinate2D(latitude: 11.0, longitude: 13.0)
        let box = BoundingBox(bottomleft, topRight)
        XCTAssertFalse(box.contains(coordinate))
    }

    func testListConstructor() throws {
        let bottomleft = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let middleTopRight = CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0)
        let topRight = CLLocationCoordinate2D(latitude: 13.0, longitude: 13.0)
        let coordinate = CLLocationCoordinate2D(latitude: 12.5, longitude: 12.5)
        let box = try XCTUnwrap(BoundingBox(from: [middleTopRight, bottomleft, topRight]))
        XCTAssertTrue(box.contains(coordinate))
        XCTAssert(bottomleft == box.southWest)
        XCTAssert(topRight == box.northEast)
    }

    func testSouthWestCoordinateOverwrite() {
        var box = BoundingBox(.sample1, .sample2)

        XCTAssertEqual(box.southWest, .sample1)

        box.southWest = .sample2
        XCTAssertEqual(box.southWest, .sample2)
    }

    func testNorthEastCoordinateOverwrite() {
        var box = BoundingBox(.sample1, .sample2)

        XCTAssertEqual(box.northEast, .sample2)

        box.northEast = .sample2
        XCTAssertEqual(box.southWest, .sample1)
    }

    func testInitWithEmptyCoordinates() {
        let box = BoundingBox(from: [])

        XCTAssertNil(box)
    }

    func testInitWithNilCoordinates() {
        let box = BoundingBox(from: nil)

        XCTAssertNil(box)
    }
}
