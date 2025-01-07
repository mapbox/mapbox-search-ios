// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

/// Options to configure a request for ``SearchEngine/retrieve(mapboxID:options:)``
public struct DetailsOptions: Sendable {
    /// Besides the basic metadata attributes, developers can request additional
    /// attributes by setting attribute_sets parameter with attribute set values,
    /// for example &attribute_sets=basic,photos,visit.
    /// The requested metadata will be provided in metadata object in the response.
    public var attributeSets: [AttributeSet]

    /// The ISO language code to be returned. If not provided, the default is English.
    public var language: String?

    /// The two digit ISO country code (such as 'JP') to request a worldview for the location data, if applicable data
    /// is available.
    /// This parameters will only be applicable for Boundaries and Places feature types.
    public var worldview: String?

    public init(attributeSets: [AttributeSet]? = nil, language: String? = nil, worldview: String? = nil) {
        // Always make sure that the basic attribute set is present
        var attributeSets: Set<AttributeSet> = Set(attributeSets ?? [.basic])
        attributeSets.insert(.basic)
        self.attributeSets = Array(attributeSets)
        self.language = language
        self.worldview = worldview
    }

    func toCore() -> CoreDetailsOptions {
        CoreDetailsOptions(
            attributeSets: attributeSets.map { NSNumber(value: $0.coreValue.rawValue) },
            language: language,
            worldview: worldview
        )
    }
}
