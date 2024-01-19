/// Type of the search result
///
/// Address types can have multiple subtypes. For example, `[.country]` for Country result like Germany or `[.address]`
/// for a concrete address.
/// Sometimes server may respond with multiple address subtypes for the result. For example, Seoul would have `[.region,
/// .place]`.
public enum SearchResultType: Codable, Hashable {
    /// Represents address type.
    ///
    /// Can have multiple subtypes. For example, `[.country]` for Country result like Germany or `[.address]` for a
    /// concrete address.
    /// Sometimes server may respond with multiple address subtypes for the result. For example, Seoul would have
    /// `[.region, .place]`.
    case address(subtypes: [SearchAddressType])

    /// Point of Interest – like restaurant, hotel or ATM
    case POI

    /// Access to `subtypes` of `address` type. Do not available for `.POI` type.
    public var addressSubtypes: [SearchAddressType]? {
        switch self {
        case .POI:
            return nil
        case .address(let subtypes):
            return subtypes
        }
    }

    enum CodingKeys: CodingKey {
        case poi, address
    }

    init?(coreResultTypes: [CoreResultType]) {
        switch coreResultTypes {
        case [.poi]:
            self = .POI
        case _ where coreResultTypes.contains(.poi):
            assertionFailure("Unsupported configuration. POI type should not be mixed")
            return nil
        case _ where CoreResultType.hasOnlyAddressSubtypes(types: coreResultTypes):
            // We do not expect multiple types to contain something rather than addresses
            self = .address(subtypes: coreResultTypes.compactMap(SearchAddressType.init))

            assert(coreResultTypes.compactMap(SearchAddressType.init).count == coreResultTypes.count)
        case _ where coreResultTypes.count > 1:
            assertionFailure("All multiple types should be Address subtypes")
            return nil
        default:
            return nil
        }
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

    /// Encode structure with your own Encoder
    /// - Parameter encoder: Custom encoder entity
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .POI:
            try container.encode(true, forKey: .poi)
        case .address(subtypes: let subtypes):
            try container.encode(subtypes, forKey: .address)
        }
    }
}
