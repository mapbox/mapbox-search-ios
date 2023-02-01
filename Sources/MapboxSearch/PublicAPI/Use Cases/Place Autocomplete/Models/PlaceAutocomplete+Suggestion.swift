// Copyright © 2022 Mapbox. All rights reserved.

import Foundation
import CoreLocation

public extension PlaceAutocomplete {
    struct Suggestion {
        /// Suggestion name.
        public let name: String
        
        /// Contains formatted address.
        public let description: String?

        /// Suggestion geographic point.
        public let coordinate: CLLocationCoordinate2D
        
        /// Icon name according to [Mapbox Maki icon set](https://github.com/mapbox/maki/)
        public let iconName: String?
        
        /// The straight line distance in meters between the origin and this suggestion.
        public let distance: CLLocationDistance?
        
        private let underlyingResult: SearchResult

        init(
            name: String,
            description: String?,
            coordinate: CLLocationCoordinate2D,
            iconName: String?,
            distance: CLLocationDistance?,
            underlyingResult: SearchResult
        ) {
            self.name = name
            self.description = description
            self.coordinate = coordinate
            self.iconName = iconName
            self.distance = distance
            self.underlyingResult = underlyingResult
        }
    }
}

// MARK: - Result
extension PlaceAutocomplete.Suggestion {
    func result() -> PlaceAutocomplete.Result {
        .init(
            name: name,
            description: description,
            coordinate: coordinate,
            iconName: iconName,
            distance: distance,
            address: underlyingResult.address,
            phone: underlyingResult.metadata?.phone,
            website: underlyingResult.metadata?.website,
            reviewCount: underlyingResult.metadata?.reviewCount,
            averageRating: underlyingResult.metadata?.averageRating,
            openHours: underlyingResult.metadata?.openHours
        )
    }
}

// MARK: - Mapping
extension PlaceAutocomplete.Suggestion {
    enum Error: Swift.Error {
        case invalidCoordinates
        case invalidResultType
    }
    
    static func from(_ searchResult: SearchResult) throws -> Self {
        guard let searchResultType = searchResult as? ServerSearchResult else {
            throw Error.invalidResultType
        }
        
        guard CLLocationCoordinate2DIsValid(searchResult.coordinate) else {
            throw Error.invalidCoordinates
        }

        return .init(
            name: searchResult.name,
            description: searchResult.descriptionText,
            coordinate: searchResult.coordinate,
            iconName: searchResult.iconName,
            distance: searchResultType.distance,
            underlyingResult: searchResult
        )
    }
}
