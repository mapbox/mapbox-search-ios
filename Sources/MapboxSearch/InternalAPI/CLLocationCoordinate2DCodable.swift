import CoreLocation
import Foundation

struct CLLocationCoordinate2DCodable: Codable, Hashable {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees

    var coordinates: CLLocationCoordinate2D {
        get { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.longitude = try container.decode(CLLocationDegrees.self)
        self.latitude = try container.decode(CLLocationDegrees.self)
    }

    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
