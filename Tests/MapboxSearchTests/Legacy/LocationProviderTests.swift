import XCTest
import CoreLocation
@testable import MapboxSearch

class LocationProviderTests: XCTestCase {
    func testPointLocationProvider() {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let pointProvider = PointLocationProvider(coordinate: coordinate)
        
        XCTAssertEqual(pointProvider.currentLocation(), coordinate)
    }
    
    func testCoordinateWrapperLocationProvider() throws {
        let coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let pointProvider = PointLocationProvider(coordinate: coordinate)
        
        let locationProviderWrapper = try XCTUnwrap(WrapperLocationProvider(wrapping: pointProvider))
        let wrapperCoordinate = try XCTUnwrap(locationProviderWrapper.getLocation())
        
        XCTAssertEqual(wrapperCoordinate.value.latitude, 40.7128)
        XCTAssertEqual(wrapperCoordinate.value.longitude, -74.0060)
    }
    
    func testNilWrapperLocationProvider() {
        let wrapperLocationProvider = WrapperLocationProvider(wrapping: nil)
        
        XCTAssertNil(wrapperLocationProvider)
    }
}
