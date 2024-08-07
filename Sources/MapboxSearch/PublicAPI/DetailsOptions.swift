// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

public struct DetailsOptions {
    /// Besides the basic metadata attributes, developers can request additional attributes by setting attribute_sets
    /// parameter with attribute set values, for example &attribute_sets=basic,photos,visit. The requested metadata will
    /// be provided in metadata object in the response.
    public var attributeSets: [AttributeSet]?

    /// The ISO language code to be returned. If not provided, the default is English.
    public var language: String?

    /// The two digit ISO country code (such as 'JP') to requests a worldview for the location data, if applicable data
    /// is available. This parameters will only be applicable for Boundaries and Places feature types.
    public var worldview: String?

    /// Base URL for server API. Default is "https://api.mapbox.com".
    /// Allows to override the URL per request.
    public var baseUrl: String?

    public init(
        attributeSets: [AttributeSet]? = nil,

        language: String? = nil,

        worldview: String? = nil,
        baseUrl: String? = nil
    ) {
        self.attributeSets = attributeSets
        self.language = language
        self.worldview = worldview
        self.baseUrl = baseUrl
    }

    func toCore() -> CoreDetailsOptions {
        .init(
            attributeSets:
            attributeSets.map { $0.map { NSNumber(value: $0.coreValue.rawValue) } },
            language: language,
            worldview: worldview,
            baseUrl: baseUrl
        )
    }
}
