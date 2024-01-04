import CoreLocation

/// Represents navigation route that consist of the set of coordinates
public class Route: Codable, Hashable {
    /// Route coordinates. Usually there are start point, turns and end point
    public var coordinates: [CLLocationCoordinate2D] {
        coordinatesCodable.map(\.coordinates)
    }

    var coordinatesCodable: [CLLocationCoordinate2DCodable]

    /// Initialize `Route` with explicit route coordinates
    /// - Parameter coordinates: route coordinates
    public init(coordinates: [CLLocationCoordinate2D]) {
        self.coordinatesCodable = coordinates.map(CLLocationCoordinate2DCodable.init)
    }

    /// Compare routes by coordinates
    public static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.coordinatesCodable == rhs.coordinatesCodable
    }

    /// Hash implementation route
    /// - Parameter hasher: system hasher
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coordinatesCodable)
    }
}
