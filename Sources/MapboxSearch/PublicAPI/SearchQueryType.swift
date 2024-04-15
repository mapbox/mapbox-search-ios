/// Enum for various filter result types.
public enum SearchQueryType {
    /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative status
    /// that has been given a designated country code under ISO 3166-1.
    case country

    /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada or
    /// China.
    case region

    /// Postal codes used in country-specific national addressing systems.
    case postcode

    /// Features that are smaller than top-level administrative features but typically larger than cities,
    /// in countries that use such an additional layer in postal addressing (for example, prefectures in China).
    case district

    /// Typically these are cities, villages, municipalities, etc.
    /// They’re usually features used in postal addressing, and are suitable for display in ambient end-user
    /// applications
    /// where current-location context is needed (for example, in weather displays).
    case place

    /// Official sub-city features present in countries where such an additional administrative layer is used in postal
    /// addressing,
    /// or where such features are commonly referred to in local parlance.
    /// Examples include city districts in Brazil and Chile and arrondissements in France.
    case locality

    /// Colloquial sub-city features often referred to in local parlance.
    /// Unlike locality features, these typically lack official status and may lack universally agreed-upon boundaries.
    case neighborhood

    /// Individual residential or business addresses.
    case address

    /// Points of interest.
    /// These include restaurants, stores, concert venues, parks, museums, etc.
    case poi

    /// The street, with no house number.
    /// - Note: Single-Box Search API only
    case street

    /// Search for categories
    /// - Note: Single-Box Search API only
    case category

    var coreValue: CoreQueryType {
        switch self {
        case .country:
            return .country
        case .region:
            return .region
        case .postcode:
            return .postcode
        case .district:
            return .district
        case .place:
            return .place
        case .locality:
            return .locality
        case .neighborhood:
            return .neighborhood
        case .address:
            return .address
        case .poi:
            return .poi
        case .street:
            return .street
        case .category:
            return .category
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func fromCoreValue(_ value: CoreQueryType) -> Self? {
        switch value {
        case .country:
            return .country
        case .region:
            return .region
        case .postcode:
            return .postcode
        case .district:
            return .district
        case .place:
            return .place
        case .locality:
            return .locality
        case .neighborhood:
            return .neighborhood
        case .address:
            return .address
        case .poi:
            return .poi
        case .street:
            return .street
        case .category:
            return category
        case .brand:
            /*
              Brand type query is not supported.
             */
            return .poi
        @unknown default:
            return nil
        }
    }
}
