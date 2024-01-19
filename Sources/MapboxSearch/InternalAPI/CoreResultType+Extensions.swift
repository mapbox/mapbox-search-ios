import Foundation

extension CoreResultType {
    var stringValue: String {
        switch self {
        case .place: return "place"
        case .street: return "street"
        case .address: return "address"
        case .postcode: return "postcode"
        case .poi: return "poi"
        case .category: return "category"
        case .query: return "query"
        case .country: return "country"
        case .region: return "region"
        case .district: return "district"
        case .locality: return "locality"
        case .userRecord: return "userRecord"
        case .neighborhood: return "neighborhood"
        case .block: return "block"
        case .brand: return "brand"
        case .unknown: fallthrough
        @unknown default:
            return "unknown"
        }
    }

    static let allAddressTypes: [CoreResultType] = [
        .address,
        .place,
        .street,
        .postcode,
        .country,
        .region,
        .district,
        .locality,
        .neighborhood,
        .block,
    ]

    /// Validate that all input types are specific address subtypes (like country, district or concrete address)
    /// - Parameter types: Mixed set of types
    /// - Returns: Does all input `types` belong to address subtypes
    static func hasOnlyAddressSubtypes(types: [CoreResultType]) -> Bool {
        Set(types).subtracting(CoreResultType.allAddressTypes).isEmpty
    }
}
