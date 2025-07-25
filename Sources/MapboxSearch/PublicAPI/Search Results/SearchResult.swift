import CoreLocation
import MapKit

/// Resolved search object with populated fields
public protocol SearchResult {
    /// Result unique identifier.
    var id: String { get }

    /// Result name.
    var name: String { get }

    /// A unique identifier for the geographic feature
    var mapboxId: String? { get }

    /// Icon name according to [Mapbox Maki icon set](https://github.com/mapbox/maki/)
    var iconName: String? { get }

    /// Index in response from server.
    var serverIndex: Int? { get }

    /// A point accuracy metric for the returned address.
    var accuracy: SearchResultAccuracy? { get }

    /// Type of SearchResult. Should be one of address or POI.
    var type: SearchResultType { get }

    /// Result coordinates.
    var coordinate: CLLocationCoordinate2D { get }

    /// The feature name, as matched by the search algorithm.
    /// Not available in ``ApiType/searchBox`` results.
    /// - Warning: The field is exposed for compatibility only and should be considered deprecated.
    var matchingName: String? { get }

    /// Result address.
    var address: Address? { get }

    /// Contains formatted address.
    var descriptionText: String? { get }

    /// POI categories. Always empty for non-POI search results.
    var categories: [String]? { get }

    /// Canonical POI category IDs. Always empty for non-POI results.
    var categoryIds: [String]? { get }

    /// Coordinates of building entries
    var routablePoints: [RoutablePoint]? { get }

    /// Original search request.
    var searchRequest: SearchRequestOptions { get }

    /// MapKit placemark
    var placemark: MKPlacemark { get }

    /// An approximate distance to the origin location, in meters.
    var distance: CLLocationDistance? { get }

    /// Estimated time of arrival (in minutes) based on specified origin point and `NavigationOptions`.
    /// Those can be specified via `SearchOptions`
    var estimatedTime: Measurement<UnitDuration>? { get }

    /// Additional search result data, such as phone number, website and other
    var metadata: SearchResultMetadata? { get }

    /// Optional bounding box that represents the geographical boundaries of a location, e.g., a building.
    var boundingBox: BoundingBox? { get }
}

extension SearchResult {
    /// MapKit placemark
    public var placemark: MKPlacemark {
        // TODO: Improve Placemark with Address and Name properties
        // Name may require inheritance
        return MKPlacemark(coordinate: coordinate)
    }
}
