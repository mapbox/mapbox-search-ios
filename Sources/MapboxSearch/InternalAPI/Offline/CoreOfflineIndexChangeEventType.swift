// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

extension CoreOfflineIndexChangeEventType: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .added:
            return "Added"
        case .removed:
            return "Removed"
        case .updated:
            return "Updated"
        @unknown default:
            return "Unknown"
        }
    }
}
