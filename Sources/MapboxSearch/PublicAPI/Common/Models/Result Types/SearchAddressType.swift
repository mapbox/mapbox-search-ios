import Foundation

/// Concrete available address types
public enum SearchAddressType: String, Hashable, Codable {
    /// Individual residential or business addresses.
    case address

    /// Typically these are cities, villages, municipalities, etc.
    /// They’re usually features used in postal addressing, and are suitable for display in ambient end-user
    /// applications
    /// where current-location context is needed (for example, in weather displays).
    case place

    /// The street, with no house number.
    case street

    /// Postal codes used in country-specific national addressing systems.
    case postcode

    /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative status
    /// that has been given a designated country code under ISO 3166-1.
    case country

    /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada or
    /// China.
    case region

    /// Features that are smaller than top-level administrative features but typically larger than cities,
    /// in countries that use such an additional layer in postal addressing (for example, prefectures in China).
    case district

    /// Official sub-city features present in countries where such an additional administrative layer is used in postal
    /// addressing,
    /// or where such features are commonly referred to in local parlance.
    /// Examples include city districts in Brazil and Chile and arrondissements in France.
    case locality

    /// Colloquial sub-city features often referred to in local parlance.
    /// Unlike locality features, these typically lack official status and may lack universally agreed-upon boundaries.
    case neighborhood

    /// The block number. Available specifically for Japan.
    case block

    // swiftlint:disable:next cyclomatic_complexity
    init?(_ core: CoreResultType) {
        switch core {
        case .address:
            self = .address

        case .place:
            self = .place

        case .street:
            self = .street

        case .postcode:
            self = .postcode

        case .country:
            self = .country

        case .region:
            self = .region

        case .district:
            self = .district

        case .locality:
            self = .locality

        case .neighborhood:
            self = .neighborhood

        case .block:
            self = .block

        case .unknown, .category, .userRecord, .query, .poi, .brand:
            fallthrough

        @unknown default:
            return nil
        }
    }
}
