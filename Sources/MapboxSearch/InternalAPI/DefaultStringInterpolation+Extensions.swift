extension DefaultStringInterpolation {
    mutating func appendInterpolation(_ api: CoreSearchEngine.ApiType) {
        let versionName: String
        switch api {
        case .geocoding:
            versionName = "geocoding"

        case .SBS:
            versionName = "SBS"

        case .searchBox:
            versionName = "searchBox"

        case .autofill:
            versionName = "autofill"

        @unknown default:
            versionName = "unknown"
        }
        appendInterpolation(versionName)
    }
}
