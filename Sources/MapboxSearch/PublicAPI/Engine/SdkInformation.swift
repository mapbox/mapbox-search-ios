import Foundation

extension SdkInformation {
    static var defaultInfo: SdkInformation {
        SdkInformation(
            name: "mapbox-search-ios",
            version: mapboxSearchSDKVersion,
            packageName: nil
        )
    }
}
