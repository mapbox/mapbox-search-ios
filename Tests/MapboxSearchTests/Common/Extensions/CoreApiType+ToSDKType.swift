@testable import MapboxSearch

extension CoreSearchEngine.ApiType {
    func toSDKType() -> ApiType? {
        switch self {
        case .geocoding:
            return .geocoding
        case .SBS:
            return .SBS
        case .autofill,
             .searchBox:
            return nil
        @unknown default:
            fatalError()
        }
    }
}
