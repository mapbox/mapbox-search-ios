// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

public struct RetrieveOptions: Sendable {
    /// Besides the basic metadata attributes, developers can request additional
    /// attributes by setting attribute_sets parameter with attribute set values,
    /// for example &attribute_sets=basic,photos,visit.
    /// The requested metadata will be provided in metadata object in the response.
    public var attributeSets: [AttributeSet]?

    public init(attributeSets: [AttributeSet]?) {
        self.attributeSets = attributeSets
    }

    func toCore() -> CoreRetrieveOptions {
        CoreRetrieveOptions(
            attributeSets:
            attributeSets?.map { NSNumber(value: $0.coreValue.rawValue) }
        )
    }
}
