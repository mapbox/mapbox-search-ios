// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

/// Determine which Mapbox API to use for a SearchEngine instance
public enum ApiType {
    /// The Mapbox Geocoding (a.k.a V5) API - https://docs.mapbox.com/api/search/geocoding/
    @available(*, deprecated, message: "Please migrate to ApiType.searchBox. This will be removed in the next release.")
    case geocoding

    /// The Mapbox Single Box Search (a.k.a Federation API) - https://docs.mapbox.com/api/search/search/
    case SBS

    case searchBox
}
