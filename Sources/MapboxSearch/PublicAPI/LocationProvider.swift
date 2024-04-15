import CoreLocation

/// Defines methods to provide location suitable for search refinement
public protocol LocationProvider {
    /// Actual device location to be used for the search purposes.
    func currentLocation() -> CLLocationCoordinate2D?
}

/// Basic location provider which returns the same coordinate on each request
open class PointLocationProvider: LocationProvider {
    /// Pinned coordinate for Location Provider
    public let coordinate: CLLocationCoordinate2D

    // MARK: Public functions

    /// Create location provider with fixed coordinate
    /// - Parameter coordinate: Pinned coordinate for Location Provider
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    /// Fixed coordinate access
    /// - Returns: Pinned coordinate for Location Provider
    public func currentLocation() -> CLLocationCoordinate2D? { coordinate }
}
