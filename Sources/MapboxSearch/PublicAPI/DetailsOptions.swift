// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

struct DetailsOptions {
    /// Besides the basic metadata attributes, developers can request additional attributes by setting attribute_sets
    /// parameter with attribute set values, for example &attribute_sets=basic,photos,visit. The requested metadata will
    /// be provided in metadata object in the response.
    var attributeSets: [AttributeSet]?

    /// The ISO language code to be returned. If not provided, the default is English.
    var language: String?

    /// The two digit ISO country code (such as 'JP') to requests a worldview for the location data, if applicable data
    /// is available. This parameters will only be applicable for Boundaries and Places feature types.
    var worldview: String?

    /// Base URL for server API. Default is "https://api.mapbox.com".
    /// Allows to override the URL per request.
    var baseUrl: String?

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
