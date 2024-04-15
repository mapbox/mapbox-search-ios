import CoreLocation
@testable import MapboxSearch
import XCTest

class LocationProviderTests: XCTestCase {
    func testPointLocationProvider() {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let pointProvider: LocationProvider = PointLocationProvider(coordinate: coordinate)

        XCTAssertEqual(pointProvider.currentLocation(), coordinate)
    }

    func testCoordinateWrapperLocationProvider() throws {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let pointProvider: LocationProvider = PointLocationProvider(coordinate: coordinate)

        let locationProviderWrapper = try XCTUnwrap(WrapperLocationProvider(wrapping: pointProvider))
        let wrapperCoordinate = try XCTUnwrap(locationProviderWrapper.getLocation())

        XCTAssertEqual(wrapperCoordinate.coordinate.latitude, 40.7128)
        XCTAssertEqual(wrapperCoordinate.coordinate.longitude, -74.0060)
    }

    func testNilWrapperLocationProvider() {
        let wrapperLocationProvider = WrapperLocationProvider(wrapping: nil)

        XCTAssertNil(wrapperLocationProvider)
    }
}
