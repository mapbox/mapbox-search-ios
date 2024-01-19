import CoreLocation
@testable import MapboxSearch
import XCTest

class WrapperLocationProviderTests: XCTestCase {
    func testLocationBypass() throws {
        let wrapperLocationProvider =
            try XCTUnwrap(WrapperLocationProvider(wrapping: PointLocationProvider(coordinate: .sample1)))

        XCTAssertEqual(wrapperLocationProvider.getLocation()?.coordinate, CLLocation.sample1.coordinate)
    }

    func testViewport() throws {
        let wrapperLocationProvider = try XCTUnwrap(WrapperLocationProvider(
            wrapping:
            PointLocationProvider(coordinate: .sample1)
        ))

        XCTAssertNil(wrapperLocationProvider.getViewport())
    }
}
