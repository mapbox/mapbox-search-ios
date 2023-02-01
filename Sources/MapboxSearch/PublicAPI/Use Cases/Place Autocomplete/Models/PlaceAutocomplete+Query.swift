// Copyright © 2022 Mapbox. All rights reserved.

import Foundation
import CoreLocation

public extension PlaceAutocomplete {
    struct TextQuery {
        public enum Requirements {
            public static let queryLength: UInt = 1
        }
                
        /// Identifies search query.
        public let value: String
        
        /// Limit results to only those contained within the supplied bounding box.
        /// The bounding box cannot cross the 180th meridian.
        public let boundingBox: BoundingBox?
                
        /// Query initializer
        /// - Parameters:
        ///   - query: query string which should satisfy all requirements defined in `Requirements` type.
        public init?(value: String, boundingBox: BoundingBox? = nil) {
            guard value.count >= Requirements.queryLength else { return nil }
                    
            self.value = value
            self.boundingBox = boundingBox
        }
    }
    
    struct CoordinateQuery {
        /// Identifies coordinates to search around.
        public let coordinate: CLLocationCoordinate2D

        /// Query initializer
        /// - Parameters:
        ///   - query: query string which should satisfy all requirements defined in `Requirements` type.
        public init?(coordinate: CLLocationCoordinate2D) {
            guard CLLocationCoordinate2DIsValid(coordinate) else { return nil }
                    
            self.coordinate = coordinate
        }
    }
}
