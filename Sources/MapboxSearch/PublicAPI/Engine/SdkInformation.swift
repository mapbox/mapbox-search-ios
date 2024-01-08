// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

extension SdkInformation {
    static func info() -> SdkInformation {
        SdkInformation(name: "mapbox-search-ios",
                       version: mapboxSearchSDKVersion,
                       packageName: nil)
    }
}
