// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

/// Determine which Mapbox API to use for a SearchEngine instance
/// NOTE: This is **unused** in the v1 Search SDK. The v2 Search SDK uses this enum to support engine types.
/// Please use the `supportSBS: Bool` parameter in AbstractSearchEngine.init in v1.
public enum ApiType {
    /// The Mapbox Geocoding (a.k.a V5) API - https://docs.mapbox.com/api/search/geocoding/
    case geocoding

    /// The Mapbox Single Box Search (a.k.a Federation API) - https://docs.mapbox.com/api/search/search/
    case SBS

    /// The current default API type for out-of-the-box use is SBS.
    public static var defaultType: Self {
        return .SBS
    }
}
