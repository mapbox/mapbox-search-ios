import CoreLocation
import Foundation

/// Bounding box  is an area defined by two longitudes and two latitudes,
/// where: Latitude is a decimal number between -90.0 and 90.0. Longitude is a decimal number between -180.0 and 180.0.
public struct BoundingBox: Codable, Hashable {
    /// The most south and west coordinate in bounding box
    public var southWest: CLLocationCoordinate2D {
        get { southWestCodable.coordinates }
        set { southWestCodable.coordinates = newValue }
    }

    /// The most north and east coordinate in bounding box
    public var northEast: CLLocationCoordinate2D {
        get { northEastCodable.coordinates }
        set { northEastCodable.coordinates = newValue }
    }

    var southWestCodable: CLLocationCoordinate2DCodable
    var northEastCodable: CLLocationCoordinate2DCodable

    /// Build `BoundingBox` with array of coordinates
    ///
    /// Constructor would search for the minimal and maximum latitude and longitude.
    /// - Parameter coordinates: Collection of coordinates. Recommended minimum is 4 coordinates and meaningful maximum.
    public init?(from coordinates: [CLLocationCoordinate2D]?) {
        guard coordinates?.count ?? 0 > 0 else {
            return nil
        }
        let startValue = (
            minLat: coordinates!.first!.latitude,
            maxLat: coordinates!.first!.latitude,
            minLon: coordinates!.first!.longitude,
            maxLon: coordinates!.first!.longitude
        )
        typealias RangeBox = (minLat: Double, maxLat: Double, minLon: Double, maxLon: Double)
        let (minLat, maxLat, minLon, maxLon) = coordinates!
            .reduce(startValue) { result, coordinate -> RangeBox in
                let minLat = min(coordinate.latitude, result.0)
                let maxLat = max(coordinate.latitude, result.1)
                let minLon = min(coordinate.longitude, result.2)
                let maxLon = max(coordinate.longitude, result.3)
                return (minLat: minLat, maxLat: maxLat, minLon: minLon, maxLon: maxLon)
            }
        self.southWestCodable = CLLocationCoordinate2DCodable(latitude: minLat, longitude: minLon)
        self.northEastCodable = CLLocationCoordinate2DCodable(latitude: maxLat, longitude: maxLon)
    }

    /// Build `BoundingBox` based on south-west (bottom-left) and north-east (top-right) coordinates
    /// - Parameters:
    ///   - southWest: The most south-west coordinate in bounding box
    ///   - northEast: The most north-east coordinate in bounding box
    public init(_ southWest: CLLocationCoordinate2D, _ northEast: CLLocationCoordinate2D) {
        self.southWestCodable = CLLocationCoordinate2DCodable(southWest)
        self.northEastCodable = CLLocationCoordinate2DCodable(northEast)
    }

    /// Returns a Boolean value indicating whether the `BoundingBox` contains the coordinate.
    /// - Parameters:
    ///   - coordinate: The coordinate to find in the bounding box.
    ///   - ignoreBoundary: `true` if coordinate on the boundary is suitable
    /// - Returns: `true` if coordinates was found
    public func contains(_ coordinate: CLLocationCoordinate2D, ignoreBoundary: Bool = true) -> Bool {
        if ignoreBoundary {
            return southWest.latitude < coordinate.latitude
                && northEast.latitude > coordinate.latitude
                && southWest.longitude < coordinate.longitude
                && northEast.longitude > coordinate.longitude
        }

        return southWest.latitude <= coordinate.latitude
            && northEast.latitude >= coordinate.latitude
            && southWest.longitude <= coordinate.longitude
            && northEast.longitude >= coordinate.longitude
    }
}
