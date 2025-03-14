// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

/// Determine which Mapbox API to use for a SearchEngine instance
public enum ApiType {
    /// The Mapbox Geocoding (a.k.a V5) API - https://docs.mapbox.com/api/search/geocoding/
    case geocoding

    /// The Mapbox Single Box Search (a.k.a Federation API) - https://docs.mapbox.com/api/search/search/
    @available(*, deprecated, message: "SBS ApiType is deprecated, use searchBox or geocoding instead.")
    case SBS

    /// Search Box API.
    /// For more information, visit [Search Box API page](https://docs.mapbox.com/api/search/search-box/).
    case searchBox

    /// The current default API type for out-of-the-box use is SBS.
    @available(*, deprecated, message: "defaultType is deprecated, specify ApiType explicitly instead.")
    public static var defaultType: Self {
        return .SBS
    }
}
