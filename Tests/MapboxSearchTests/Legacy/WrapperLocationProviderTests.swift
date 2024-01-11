import XCTest
@testable import MapboxSearch
import CoreLocation

class WrapperLocationProviderTests: XCTestCase {
    func testLocationBypass() throws {
        let wrapperLocationProvider = try XCTUnwrap(WrapperLocationProvider(wrapping:
            PointLocationProvider(coordinate: .sample1)))

        XCTAssertEqual(wrapperLocationProvider.getLocation()?.value, CLLocation.sample1.coordinate)
    }

    func testViewport() throws {
        let wrapperLocationProvider = try XCTUnwrap(WrapperLocationProvider(wrapping:
            PointLocationProvider(coordinate: .sample1)))

        XCTAssertNil(wrapperLocationProvider.getViewport())
    }
}
