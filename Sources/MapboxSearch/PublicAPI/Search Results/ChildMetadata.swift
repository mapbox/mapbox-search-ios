// Copyright © 2024 Mapbox. All rights reserved.

import Foundation
import MapKit

// x / SearchResult additional information, such as phone, website and etc.
// x / Extra metadata contained in data field as dictionary.
public struct ChildMetadata: Codable, Hashable {
    public var mapboxId: String
    public var name: String
    public var category: String
    /// Coordinate associated to the favorite record.
    public internal(set) var coordinates: CLLocationCoordinate2D {
        get {
            coordinatesCodable.coordinates
        }
        set {
            coordinatesCodable = .init(newValue)
        }
    }

    var coordinatesCodable: CLLocationCoordinate2DCodable

    init(metadata: CoreChildMetadata) {
        self.mapboxId = metadata.mapboxId
        self.name = metadata.name
        self.category = metadata.category
        self.coordinatesCodable = .init(metadata.coordinates)
    }
}
