// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

public extension PlaceAutocomplete {
    struct Result {
        /// Result name.
        public let name: String
        
        /// Contains formatted address.
        public let description: String?

        /// result geographic point.
        public let coordinate: CLLocationCoordinate2D
        
        /// Icon name according to [Mapbox Maki icon set](https://github.com/mapbox/maki/)
        public let iconName: String?
        
        /// The straight line distance in meters between the origin and this suggestion.
        public let distance: CLLocationDistance?
        
        /// Textual representation of the address.
        public let address: Address?
        
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
    }
}