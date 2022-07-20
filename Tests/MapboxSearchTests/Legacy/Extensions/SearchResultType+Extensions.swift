@testable import MapboxSearch

extension SearchResultType {
    var coreType: CoreResultType {
        switch self {
        case .address:
            return .address
        case .POI:
            return .poi
        }
    }
}
