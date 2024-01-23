import Foundation

/// Contains values for a given country including name (required) and possibly ISO 3166-1 Alpha 2 and Alpha 3 codes.
public struct SearchAddressCountry: Codable, Hashable, Equatable {
    /// Name of this country
    var name: String

    /// ISO 3166-1 Alpha 2 country code
    var countryCode: String?

    /// ISO 3166-1 Alpha 3 country code
    var countryCodeAlpha3: String?

    init(_ core: CoreSearchAddressCountry) {
        self.name = core.name
        self.countryCode = core.countryCode
        self.countryCodeAlpha3 = core.countryCodeAlpha3
    }
}

extension SearchAddressCountry {
    /// Transform a ``SearchAddressCountry`` to an object compatible with the MapboxCommon framework.
    func toCore() -> CoreSearchAddressCountry {
        CoreSearchAddressCountry(
            name: name,
            countryCode: countryCode,
            countryCodeAlpha3: countryCodeAlpha3
        )
    }
}
