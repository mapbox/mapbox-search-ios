import Foundation
import MapboxCoreSearch

public struct AdministrativeUnit: Equatable {
    let rawValue: QueryType

    @available(*, deprecated, message: "Use `init(queryType:)` instead")
    public init(rawValue: SearchQueryType) {
        self.rawValue = rawValue.queryType
    }

    public init(queryType: QueryType) {
        self.rawValue = queryType
    }

    /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative status
    /// that has been given a designated country code under ISO 3166-1.
    public static let country: AdministrativeUnit = .init(queryType: .country)

    /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada or
    /// China.
    public static let region: AdministrativeUnit = .init(queryType: .region)

    /// Postal codes used in country-specific national addressing systems.
    public static let postcode: AdministrativeUnit = .init(queryType: .postcode)

    /// Features that are smaller than top-level administrative features but typically larger than cities, in countries
    /// that use such an additional layer in postal addressing (for example, prefectures in China).
    public static let district: AdministrativeUnit = .init(queryType: .district)

    /// Typically these are cities, villages, municipalities, etc.
    /// They’re usually features used in postal addressing, and are suitable for display in ambient end-user
    /// applications where current-location context is needed (for example, in weather displays).
    public static let place: AdministrativeUnit = .init(queryType: .place)

    /// Official sub-city features present in countries where such an additional administrative layer is used in postal
    /// addressing, or where such features are commonly referred to in local parlance.
    /// Examples include city districts in Brazil and Chile and arrondissements in France.
    public static let locality: AdministrativeUnit = .init(queryType: .locality)

    /// Colloquial sub-city features often referred to in local parlance. Unlike locality features, these typically lack
    /// official status and may lack universally agreed-upon boundaries.
    /// - Note: Not available for reverse geocoding requests.
    public static let neighborhood: AdministrativeUnit = .init(queryType: .neighborhood)

    /// The street, with no house number.
    public static let street: AdministrativeUnit = .init(queryType: .street)

    /// Individual residential or business addresses as a street with house number. In a Japanese context, this is the
    /// block number and the house number. All components smaller than chome are designated as an address.
    public static let address: AdministrativeUnit = .init(queryType: .address)

    /// Japanese administrative unit analogous to `place`.
    public static let city: AdministrativeUnit = .init(queryType: .place)

    /// Japanese administrative unit analogous to `region`.
    public static let prefecture: AdministrativeUnit = .init(queryType: .region)

    /// Japanese administrative unit analogous to `locality`.
    public static let oaza: AdministrativeUnit = .init(queryType: .locality)

    /// Japanese administrative unit analogous to `neighborhood`.
    /// - Note: Not available for reverse geocoding requests.
    public static let chome: AdministrativeUnit = .init(queryType: .neighborhood)

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
