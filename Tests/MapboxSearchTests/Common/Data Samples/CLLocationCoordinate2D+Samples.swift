import CoreLocation
@testable import MapboxSearch

extension CLLocationCoordinate2D {
    /// Mapbox SF Office
    static let sample1 = CLLocationCoordinate2D(latitude: 37.7913235, longitude: -122.3964788)

    /// Mapbox DC Office
    static let sample2 = CLLocationCoordinate2D(latitude: 38.8996104, longitude: -77.0341996)
}

extension CLLocation {
    static let sample1 = CLLocation(
        latitude: CLLocationCoordinate2D.sample1.latitude,
        longitude: CLLocationCoordinate2D.sample1.longitude
    )
    static let sample2 = CLLocation(
        latitude: CLLocationCoordinate2D.sample2.latitude,
        longitude: CLLocationCoordinate2D.sample2.longitude
    )
}

extension CLLocationCoordinate2DCodable {
    static let sample1 = CLLocationCoordinate2DCodable(.sample1)
    static let sample2 = CLLocationCoordinate2DCodable(.sample2)
}
