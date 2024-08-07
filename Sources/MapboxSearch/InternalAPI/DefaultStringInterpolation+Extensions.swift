extension DefaultStringInterpolation {
    mutating func appendInterpolation(_ api: CoreSearchEngine.ApiType) {
        let versionName = switch api {
        case .geocoding:
            "geocoding"

        case .SBS:
            "SBS"

        case .searchBox:
            "searchBox"

        case .autofill:
            "autofill"

        @unknown default:
            "unknown"
        }
        appendInterpolation(versionName)
    }
}
