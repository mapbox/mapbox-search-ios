import CoreLocation
@testable import MapboxSearch

extension CoreBoundingBox {
    override open func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? CoreBoundingBox {
            return min == rhs.min && max == rhs.max
        } else {
            return false
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
