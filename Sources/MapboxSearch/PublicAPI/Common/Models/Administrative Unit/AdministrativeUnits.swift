import Foundation

public struct AdministrativeUnit: Equatable {
    let rawValue: SearchQueryType

    public init(rawValue: SearchQueryType) {
        self.rawValue = rawValue
    }

    /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative status
    /// that has been given a designated country code under ISO 3166-1.
    public static let country: AdministrativeUnit = .init(rawValue: .country)

    /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada or
    /// China.
    public static let region: AdministrativeUnit = .init(rawValue: .region)

    /// Postal codes used in country-specific national addressing systems.
    public static let postcode: AdministrativeUnit = .init(rawValue: .postcode)

    /// Features that are smaller than top-level administrative features but typically larger than cities, in countries
    /// that use such an additional layer in postal addressing (for example, prefectures in China).
    public static let district: AdministrativeUnit = .init(rawValue: .district)

    /// Typically these are cities, villages, municipalities, etc.
    /// They’re usually features used in postal addressing, and are suitable for display in ambient end-user
    /// applications where current-location context is needed (for example, in weather displays).
    public static let place: AdministrativeUnit = .init(rawValue: .place)

    /// Official sub-city features present in countries where such an additional administrative layer is used in postal
    /// addressing, or where such features are commonly referred to in local parlance.
    /// Examples include city districts in Brazil and Chile and arrondissements in France.
    public static let locality: AdministrativeUnit = .init(rawValue: .locality)

    /// Colloquial sub-city features often referred to in local parlance. Unlike locality features, these typically lack
    /// official status and may lack universally agreed-upon boundaries.
    /// - Note: Not available for reverse geocoding requests.
    public static let neighborhood: AdministrativeUnit = .init(rawValue: .neighborhood)

    /// The street, with no house number.
    public static let street: AdministrativeUnit = .init(rawValue: .street)

    /// Individual residential or business addresses as a street with house number. In a Japanese context, this is the
    /// block number and the house number. All components smaller than chome are designated as an address.
    public static let address: AdministrativeUnit = .init(rawValue: .address)

    /// Japanese administrative unit analogous to `place`.
    public static let city: AdministrativeUnit = .init(rawValue: .place)

    /// Japanese administrative unit analogous to `region`.
    public static let prefecture: AdministrativeUnit = .init(rawValue: .region)

    /// Japanese administrative unit analogous to `locality`.
    public static let oaza: AdministrativeUnit = .init(rawValue: .locality)

    /// Japanese administrative unit analogous to `neighborhood`.
    /// - Note: Not available for reverse geocoding requests.
    public static let chome: AdministrativeUnit = .init(rawValue: .neighborhood)

    public static var all: [AdministrativeUnit] {
        [
            .country,
            .region,
            .postcode,
            .district,
            .place,
            .locality,
            .neighborhood,
            .street,
            .address,
            .city,
            prefecture,
            .oaza,
            chome,
        ]
    }
}
