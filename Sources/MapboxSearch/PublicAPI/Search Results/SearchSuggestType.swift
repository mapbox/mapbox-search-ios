/// Suggestion type
public enum SearchSuggestType: Codable, Hashable {
    /// Represents address type.
    ///
    /// Can have multiple subtypes. For example, `[.country]` for Country result like Germany or `[.address]` for a
    /// concrete address.
    /// Sometimes server may respond with multiple address subtypes for the result. For example, Seoul would have
    /// `[.region, .place]`.
    case address(subtypes: [SearchAddressType])

    /// Suggestion represents point-of-interest.
    case POI

    /// Suggestion represents further category search.
    /// For example, you may get "bar" category suggestion for "bar" query
    /// to look for a POI with "bar" in the categories field.
    case category

    /// Suggestion represents the further query search.
    /// It might be used for query corrections.
    case query

    /// Access to `subtypes` of `address` type. Do not available for `.POI` type.
    public var addressSubtypes: [SearchAddressType]? {
        switch self {
        case .address(let subtypes):
            return subtypes
        case .POI, .category, .query:
            return nil
        }
    }

    enum CodingKeys: CodingKey {
        case poi, address, category, query
    }

    /// Initializer for custom Decoder
    /// - Parameter decoder: Decoder class
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch container.allKeys.first {
        case .poi:
            self = .POI
        case .address:
            let types = try container.decode([SearchAddressType].self, forKey: .address)
            self = .address(subtypes: types)
        case .category:
            self = .category
        case .query:
            self = .query
        case nil:
            var path = container.codingPath
            if let firstKey = container.allKeys.first {
                path.append(firstKey)
            }
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: path,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }

    init(resultType: SearchResultType) {
        switch resultType {
        case .POI:
            self = .POI
        case .address(let subtypes):
            self = .address(subtypes: subtypes)
        }
    }

    /// Encode structure with your own Encoder
    /// - Parameter encoder: Custom encoder entity
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .POI:
            try container.encode(true, forKey: .poi)
        case .address(subtypes: let subtypes):
            try container.encode(subtypes, forKey: .address)
        case .category:
            try container.encode(true, forKey: .category)
        case .query:
            try container.encode(true, forKey: .query)
        }
    }
}
