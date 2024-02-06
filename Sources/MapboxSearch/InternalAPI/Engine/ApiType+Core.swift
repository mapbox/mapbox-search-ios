// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

extension ApiType {
    func toCore() -> CoreSearchEngine.ApiType {
        switch self {
        case .geocoding:
            return .geocoding
        case .SBS:
            return .SBS
        }
    }
}
