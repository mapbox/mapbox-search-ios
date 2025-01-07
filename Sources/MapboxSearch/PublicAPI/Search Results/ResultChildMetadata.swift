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

    /// Initializes a new instance of `ResultChildMetadata` with optional category, coordinates, and name,
    /// and a required `mapboxId`.
    ///
    /// - Parameters:
    ///   - mapboxId: A required `String` that uniquely identifies the Mapbox object. This is a required
    ///     parameter and must be provided during initialization.
    ///   - name: An optional `String` representing the name of the result.
    ///   - category: An optional `String` representing the category of the result.
    ///   - coordinate: An optional `CLLocationCoordinate2D` representing the geographical location
    ///     associated with the result. If provided, it is transformed to a `CLLocationCoordinate2DCodable`
    ///     instance for storage.
    public init(
        mapboxId: String,
        name: String? = nil,
        category: String? = nil,
        coordinate: CLLocationCoordinate2D? = nil
    ) {
        self.category = category
        self.coordinatesCodable = coordinate.map(CLLocationCoordinate2DCodable.init)
        self.mapboxId = mapboxId
        self.name = name
    }
}
