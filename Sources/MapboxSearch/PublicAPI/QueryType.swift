import MapboxCoreSearch

/// A type that represents a search query filter.
///
/// Use the provided static constants to specify which kinds of results to include in a search.
///
/// ```swift
/// let options = SearchOptions(types: [.place, .address])
/// ```
public struct QueryType: Equatable, Sendable {
    public let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative
    /// status that has been given a designated country code under ISO 3166-1.
    public static let country = QueryType(rawValue: "country")

    /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada or
    /// China.
    public static let region = QueryType(rawValue: "region")

    /// Postal codes used in country-specific national addressing systems.
    public static let postcode = QueryType(rawValue: "postcode")

    /// Features that are smaller than top-level administrative features but typically larger than cities,
    /// in countries that use such an additional layer in postal addressing (for example, prefectures in China).
    public static let district = QueryType(rawValue: "district")

    /// Typically these are cities, villages, municipalities, etc.
    /// They're usually features used in postal addressing, and are suitable for display in ambient end-user
    /// applications where current-location context is needed (for example, in weather displays).
    public static let place = QueryType(rawValue: "place")

    /// Official sub-city features present in countries where such an additional administrative layer is used in postal
    /// addressing, or where such features are commonly referred to in local parlance.
    /// Examples include city districts in Brazil and Chile and arrondissements in France.
    public static let locality = QueryType(rawValue: "locality")

    /// Colloquial sub-city features often referred to in local parlance.
    /// Unlike locality features, these typically lack official status and may lack universally agreed-upon boundaries.
    public static let neighborhood = QueryType(rawValue: "neighborhood")

    /// Individual residential or business addresses.
    public static let address = QueryType(rawValue: "address")

    /// Points of interest.
    /// These include restaurants, stores, concert venues, parks, museums, etc.
    public static let poi = QueryType(rawValue: "poi")

    /// The street, with no house number.
    /// - Note: Single-Box Search API only
    public static let street = QueryType(rawValue: "street")

    /// Search for categories.
    /// - Note: Single-Box Search API only
    public static let category = QueryType(rawValue: "category")

    /// Search for categories.
    /// - Note: Single-Box Search API only
    public static let brand = QueryType(rawValue: "brand")

    var coreValue: CoreQueryType? {
        switch self {
        case .country: return .country
        case .region: return .region
        case .postcode: return .postcode
        case .district: return .district
        case .place: return .place
        case .locality: return .locality
        case .neighborhood: return .neighborhood
        case .address: return .address
        case .poi: return .poi
        case .street: return .street
        case .category: return .category
        case .brand: return .brand
        default: return nil
        }
    }

    static func fromCoreValue(_ value: CoreQueryType) -> Self? {
        switch value {
        case .country: return .country
        case .region: return .region
        case .postcode: return .postcode
        case .district: return .district
        case .place: return .place
        case .locality: return .locality
        case .neighborhood: return .neighborhood
        case .address: return .address
        case .poi: return .poi
        case .street: return .street
        case .category: return .category
        case .brand: return .brand
        default: return nil
        }
    }
}
