import CoreLocation
import Foundation

class WrapperLocationProvider: CoreLocationProvider {
    func getViewport() -> CoreBoundingBox? {
        // https://mapbox.slack.com/archives/GNH1NL3D5/p1584710461014400
        // Implement to support ViewPort argument for Telemetry
        return nil
    }

    private let locationProvider: LocationProvider

    init?(wrapping locationProvider: LocationProvider?) {
        guard let locationProvider else { return nil }
        self.locationProvider = locationProvider
    }

    func getLocation() -> Coordinate2D? {
        guard let location = locationProvider.currentLocation() else {
            return nil
        }
        return Coordinate2D(value: location)
    }
}
