import CoreLocation
@testable import MapboxSearch

extension CLLocationCoordinate2D {
    /// Mapbox SF Office
    static let sample1 = CLLocationCoordinate2D(latitude: 37.7913235, longitude: -122.3964788)

    /// Mapbox DC Office
    static let sample2 = CLLocationCoordinate2D(latitude: 38.8996104, longitude: -77.0341996)

    /// Mapbox Berlin Office
    static let sample3 = CLLocationCoordinate2D(latitude: 52.5023494, longitude: 13.4223088)
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

extension Coordinate2D {
    static let sample1 = Coordinate2D(value: .sample1)
    static let sample2 = Coordinate2D(value: .sample2)
}
