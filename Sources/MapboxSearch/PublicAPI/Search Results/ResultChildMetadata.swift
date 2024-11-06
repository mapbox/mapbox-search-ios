// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

public struct ResultChildMetadata: Codable, Hashable {
    public var category: String?

    public var coordinates: CLLocationCoordinate2D? {
        coordinatesCodable?.coordinates
    }

    var coordinatesCodable: CLLocationCoordinate2DCodable?

    public var mapboxId: String

    public var name: String?

    init(resultChildMetadata: CoreResultChildMetadata) {
        self.category = resultChildMetadata.category
        self.mapboxId = resultChildMetadata.mapboxId
        if let coordinates = resultChildMetadata.coordinates?.value {
            self.coordinatesCodable = CLLocationCoordinate2DCodable(coordinates)
        }
        self.name = resultChildMetadata.name
    }

    public init(
        category: String? = nil,
        coordinate: CLLocationCoordinate2D? = nil,
        mapboxId: String,
        name: String? = nil
    ) {
        self.category = category
        self.coordinatesCodable = coordinate.map(CLLocationCoordinate2DCodable.init)
        self.mapboxId = mapboxId
        self.name = name
    }
}
