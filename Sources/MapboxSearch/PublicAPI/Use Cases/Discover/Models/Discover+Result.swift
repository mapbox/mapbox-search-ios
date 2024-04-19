import CoreLocation
import Foundation

extension Discover {
    public struct Result {
        /// Result's name
        public let name: String

        /// A unique identifier for the geographic feature
        public let mapboxId: String?

        /// Result's address
        public let address: AddressComponents

        /// Result's geographic point.
        public let coordinate: CLLocationCoordinate2D

        /// List of points near [coordinate], that represents entries to associated building.
        public let routablePoints: NonEmptyArray<RoutablePoint>?

        /// POI categories.
        public let categories: [String]

        /// [Maki](https://github.com/mapbox/maki/) icon name for the place.
        public let makiIcon: String?
    }
}

extension Discover.Result {
    static func from(_ searchResult: SearchResult) -> Self {
        var routablePointsArray: NonEmptyArray<RoutablePoint>?
        if let routablePoints = searchResult.routablePoints, let first = searchResult.routablePoints?.first {
            routablePointsArray = .init(first: first, others: Array(routablePoints.dropFirst()))
        } else {
            routablePointsArray = nil
        }

        return .init(
            name: searchResult.name,
            mapboxId: searchResult.mapboxId,
            address: .init(searchResult: searchResult),
            coordinate: searchResult.coordinate,
            routablePoints: routablePointsArray,
            categories: searchResult.categories ?? [],
            makiIcon: searchResult.iconName
        )
    }
}
