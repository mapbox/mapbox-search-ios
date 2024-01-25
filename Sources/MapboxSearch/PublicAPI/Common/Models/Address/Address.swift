import Contacts
import Foundation

/// Address separated by the components
public struct Address: Codable, Hashable {
    /// House number of the individual residential or business addresses.
    public var houseNumber: String?

    /// Street name of the individual residential or business addresses.
    public var street: String?

    /// Colloquial sub-city features often referred to in local parlance.
    /// Unlike locality features, these typically lack official status and may lack universally agreed-upon boundaries.
    public var neighborhood: String?

    /// Official sub-city features present in countries where such an additional administrative layer is used in postal
    /// addressing,
    /// or where such features are commonly referred to in local parlance.
    /// Examples include city districts in Brazil and Chile and arrondissements in France.
    public var locality: String?

    /// Postal codes used in country-specific national addressing systems.
    public var postcode: String?

    /// Typically these are cities, villages, municipalities, etc.
    /// They’re usually features used in postal addressing, and are suitable for display in ambient end-user
    /// applications
    /// where current-location context is needed (for example, in weather displays).
    public var place: String?

    /// Features that are smaller than top-level administrative features but typically larger than cities,
    /// in countries that use such an additional layer in postal addressing (for example, prefectures in China).
    public var district: String?

    /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada or
    /// China.
    public var region: String?

    /// Top-level sub-national administrative feature object containing the name (required) and ISO 3166-2 subdivision
    /// code identifiers.
    public var searchAddressRegion: SearchAddressRegion?

    /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative status
    /// that has been given a designated country code under ISO 3166-1.
    public var country: String?

    /// Generally recognized country object containing the name (required) and ISO 3166-1 country code identifiers.
    public var searchAddressCountry: SearchAddressCountry?

    /// The postal address associated with the location, formatted for use with the Contacts framework.
    public var postalAddress: CNPostalAddress {
        let streetNameAndNumber = [houseNumber, street]
            .compactMap { $0?.isEmpty == false ? $0 : nil }
            .joined(separator: " ")

        let address = CNMutablePostalAddress()
        address.street = streetNameAndNumber
        address.subLocality = neighborhood ?? ""
        address.postalCode = postcode ?? ""
        address.country = country ?? ""
        address.state = region ?? ""
        address.city = place ?? ""

        return address
    }

    public static var empty: Address {
        .init(
            houseNumber: nil,
            street: nil,
            neighborhood: nil,
            locality: nil,
            postcode: nil,
            place: nil,
            district: nil,
            region: nil,
            country: nil
        )
    }
}

extension Address {
    init(coreAddress: CoreAddress) {
        func valueOrNil(_ input: String?) -> String? {
            if input?.isEmpty == true {
                return nil
            }
            return input
        }

        self.init(
            houseNumber: valueOrNil(coreAddress.houseNumber),
            street: valueOrNil(coreAddress.street),
            neighborhood: valueOrNil(coreAddress.neighborhood),
            locality: valueOrNil(coreAddress.locality),
            postcode: valueOrNil(coreAddress.postcode),
            place: valueOrNil(coreAddress.place),
            district: valueOrNil(coreAddress.district),
            region: valueOrNil(coreAddress.region?.name),
            searchAddressRegion: coreAddress.region.map { SearchAddressRegion($0) },
            country: valueOrNil(coreAddress.country?.name),
            searchAddressCountry: coreAddress.country.map { SearchAddressCountry($0) }
        )
    }

    func coreAddress() -> CoreAddress {
        CoreAddress(
            houseNumber: houseNumber,
            street: street,
            neighborhood: neighborhood,
            locality: locality,
            postcode: postcode,
            place: place,
            district: district,
            region: searchAddressRegion?.toCore(),
            country: searchAddressCountry?.toCore()
        )
    }
}

extension Address {
    // TODO: https://github.com/mapbox/mapbox-search-ios/issues/124
    // Consider to add smart format style
    // Currently we have problem when style may return nil for adress.
    // City for example has only region and country and medium style returns nil adress

    /// Address format style manage address string representation
    public enum AddressFormatStyle {
        /// House number and street name
        case short

        /// House number, street name and place name (city). For region-based contries (like USA), the State name will
        /// be appended
        case medium

        /// All address components (if available) without postcode
        case long

        /// All available address components
        case full

        /// Provide `Address` keypaths to build your own format. No additional country-based logic would be applied
        case custom(components: [KeyPath<Address, String?>])
    }

    /// Build address string in requested style. All empty components will be skipped.
    /// Separator ", " would be used to join all the components. House number will separated with " " separator
    /// For example, for `.short` style: "50 Beale St, 9th Floor" and for `.medium` – "50 Beale St, 9th Floor, San
    /// Francisco, California"
    /// - Parameter style: address style to be used
    /// - Returns: Address string
    public func formattedAddress(style: AddressFormatStyle) -> String? {
        // All styles will include \.houseNumber if it exist
        let componentPaths: [KeyPath<Address, String?>]
        switch style {
        case .short:
            componentPaths = [\.houseNumber, \.street]
        case .medium:
            if let country, regionBasedCountry(country) {
                componentPaths = [\.houseNumber, \.street, \.place, \.region]
            } else {
                componentPaths = [\.houseNumber, \.street, \.place]
            }
        case .long:
            componentPaths = [
                \.houseNumber,
                \.street,
                \.neighborhood,
                \.locality,
                \.place,
                \.district,
                \.region,
                \.country,
            ]
        case .full:
            componentPaths = [
                \.houseNumber,
                \.street,
                \.neighborhood,
                \.locality,
                \.place,
                \.district,
                \.region,
                \.country,
                \.postcode,
            ]
        case .custom(let components):
            componentPaths = components
        }

        // Take actual non-nil components
        let components = componentPaths.map { self[keyPath: $0] }.compactMap { $0 }.filter { !$0.isEmpty }
        guard !components.isEmpty else { return nil }

        let separator = ", "

        if componentPaths.first == \.houseNumber, let houseNumber {
            if components.count == 1 {
                return houseNumber
            } else {
                return houseNumber + " " + components.dropFirst().joined(separator: separator)
            }
        } else {
            return components.joined(separator: separator)
        }
    }

    private func regionBasedCountry(_ country: String) -> Bool {
        ["united states of america", "usa"].contains(country.lowercased())
    }
}
