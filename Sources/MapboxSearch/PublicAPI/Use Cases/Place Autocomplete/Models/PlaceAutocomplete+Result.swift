import Foundation

extension PlaceAutocomplete {
    public struct Result {
        /// Result name.
        public let name: String

        public let mapboxId: String?

        /// Contains formatted address.
        public let description: String?

        /// The type of result.
        public let type: SearchResultType

        /// result geographic point.
        public let coordinate: CLLocationCoordinate2D?

        /// Icon name according to [Mapbox Maki icon set](https://github.com/mapbox/maki/)
        public let iconName: String?

        /// The straight line distance in meters between the origin and this suggestion.
        public let distance: CLLocationDistance?

        /// Estimated time of arrival (in minutes) based on specified `proximity`.
        public let estimatedTime: Measurement<UnitDuration>?

        /// List of points near [coordinate], that represents entries to associated building.
        public let routablePoints: [RoutablePoint]

        /// Poi categories. Always empty for non-POI suggestions.
        public let categories: [String]

        /// Type representing address components.
        public let address: AddressComponents?

        /// Business phone number
        public let phone: String?

        /// Business website
        public let website: URL?

        /// Number of reviews
        public let reviewCount: Int?

        /// Average rating
        public let averageRating: Double?

        /// Business opening hours
        public let openHours: OpenHours?

        /// Primary image
        public let primaryImage: Image?

        /// Additional images
        public var otherImages: [Image]?
    }
}
