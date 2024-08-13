// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

public enum AttributeSet: CaseIterable, Codable, Hashable, Sendable {
    /** Essential information about a location such as name, address and coordinates. This is the default value for attribute_sets parameter, and will be provided when attribute_sets is not provided in the request. */
    case basic

    /** A collection of photos related to the location. */
    case photos

    /** Specific information about the location including a detailed description text, user reviews, price level and popularity. */
    case venue

    /** Visiting information for the location like website, phone number and social media handles. */
    case visit

    var coreValue: CoreAttributeSet {
        switch self {
        case .basic:
            .basic
        case .photos:
            .photos
        case .venue:
            .venue
        case .visit:
            .visit
        }
    }

    static func fromCoreValue(_ value: CoreAttributeSet) -> Self? {
        switch value {
        case .basic:
            return .basic
        case .photos:
            return .photos
        case .venue:
            return .venue
        case .visit:
            return .visit
        @unknown default:
            return nil
        }
    }
}
