import CoreLocation
@testable import MapboxSearch
import ObjectiveC
import XCTest

class DefaultLocationProviderTests: XCTestCase {
    var locationProvider: DefaultLocationProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        locationProvider = DefaultLocationProvider()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        locationProvider = nil
    }

    func testWrapperLocationProviderForNilLocations() throws {
        try XCTSkipIf([.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus()))

        let wrapperLocationProvider = try XCTUnwrap(WrapperLocationProvider(wrapping: DefaultLocationProvider()))

        XCTAssertNil(wrapperLocationProvider.getLocation())
    }

    func testParametersForDefaultLocationProvider() {
        let defaultLocationProvider = DefaultLocationProvider(
            distanceFilter: CLLocationDistanceMax,
            desiredAccuracy: kCLLocationAccuracyBestForNavigation,
            activityType: .fitness
        )

        XCTAssertEqual(defaultLocationProvider.locationManager.distanceFilter, CLLocationDistanceMax)
        XCTAssertEqual(defaultLocationProvider.locationManager.desiredAccuracy, kCLLocationAccuracyBestForNavigation)
        XCTAssertEqual(defaultLocationProvider.locationManager.activityType, .fitness)
    }

    func testCustomLocationManagerForDefaultLocationProvider() {
        let customLocationManager = CLLocationManager()
        let defaultLocationProvider = DefaultLocationProvider(locationManager: customLocationManager)

        XCTAssertEqual(defaultLocationProvider.locationManager, customLocationManager)
    }

    func testDefaultLocationProviderCurrentLocation() throws {
        let defaultLocationProvider = DefaultLocationProvider()
        let locationDelegate = defaultLocationProvider.locationManager.delegate

        let stubLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
        locationDelegate?.locationManager?(defaultLocationProvider.locationManager, didUpdateLocations: [stubLocation])

        let currentLocation = try XCTUnwrap(defaultLocationProvider.currentLocation())
        XCTAssertEqual(currentLocation.latitude, 40.7128)
        XCTAssertEqual(currentLocation.longitude, -74.0060)
    }

    func testSystemPausesInDefaultLocationProvider() {
        let defaultLocationProvider = DefaultLocationProvider(desiredAccuracy: kCLLocationAccuracyBestForNavigation)
        let locationDelegate = defaultLocationProvider.locationManager.delegate

        XCTAssertEqual(defaultLocationProvider.locationManager.desiredAccuracy, kCLLocationAccuracyBestForNavigation)

        locationDelegate?.locationManagerDidPauseLocationUpdates?(defaultLocationProvider.locationManager)
        XCTAssertEqual(defaultLocationProvider.locationManager.desiredAccuracy, kCLLocationAccuracyThreeKilometers)

        locationDelegate?.locationManagerDidResumeLocationUpdates?(defaultLocationProvider.locationManager)
        XCTAssertEqual(defaultLocationProvider.locationManager.desiredAccuracy, kCLLocationAccuracyBestForNavigation)
    }
}
