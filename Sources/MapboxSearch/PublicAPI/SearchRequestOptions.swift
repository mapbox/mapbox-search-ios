import CoreLocation

/// Possible options for search request
public struct SearchRequestOptions: Equatable, Hashable, Codable {
    /// Search query
    public let query: String

    /// Coordinate to search around
    public var proximity: CLLocationCoordinate2D? {
        proximityCodable?.coordinates
    }

    let proximityCodable: CLLocationCoordinate2DCodable?

    public init(query: String, proximity: CLLocationCoordinate2D?) {
        self.query = query
        self.proximityCodable = proximity.map(CLLocationCoordinate2DCodable.init)
    }
}
