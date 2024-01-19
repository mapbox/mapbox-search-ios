import CoreLocation
import Foundation

/// Point on the road the feature fronts.
public struct RoutablePoint: Codable, Hashable {
    /// Building front coordinate.
    public var point: CLLocationCoordinate2D {
        pointCodable.coordinates
    }

    let pointCodable: CLLocationCoordinate2DCodable

    /// Name of the routable point.
    public let name: String

    init(name: String, point: CLLocationCoordinate2DCodable) {
        self.name = name
        self.pointCodable = point
    }

    init(routablePoint: CoreRoutablePoint) {
        self.name = routablePoint.name
        self.pointCodable = .init(routablePoint.point)
    }
}
