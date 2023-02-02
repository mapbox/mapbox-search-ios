// Copyright © 2023 Mapbox. All rights reserved.

import Foundation
import CoreLocation

public extension DiscoverAPI {
    struct Result {
        /// Result's name
        public let name: String
        
        /// Result's address
        public let address: Address
        
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

extension DiscoverAPI.Result {
    static func from(_ searchResult: SearchResult) -> Self {
        .init(
            name: searchResult.name,
            address: searchResult.address ?? .empty,
            coordinate: searchResult.coordinate,
            routablePoints: nil,
            categories: searchResult.categories ?? [],
            makiIcon: searchResult.iconName
        )
    }
}
