import Foundation

extension AddressAutofill {
    public struct AddressComponent: Equatable {
        public let kind: Kind
        public let value: String
    }
}

extension AddressAutofill.AddressComponent {
    public enum Kind: String, Hashable, Codable, CaseIterable {
        /// House number of the individual residential or business addresses.
        case houseNumber // swiftlint:disable:this raw_value_for_camel_cased_codable_enum

        /// Street name of the individual residential or business addresses.
        case street

        /// Colloquial sub-city features often referred to in local parlance.
        /// Unlike locality features, these typically lack official status and may lack universally agreed-upon
        /// boundaries.
        case neighborhood

        /// Official sub-city features present in countries where such an additional administrative layer is used in
        /// postal addressing,
        /// or where such features are commonly referred to in local parlance.
        /// Examples include city districts in Brazil and Chile and arrondissements in France.
        case locality

        /// Postal codes used in country-specific national addressing systems.
        case postcode

        /// Typically these are cities, villages, municipalities, etc.
        /// They’re usually features used in postal addressing, and are suitable for display in ambient end-user
        /// applications
        /// where current-location context is needed (for example, in weather displays).
        case place

        /// Features that are smaller than top-level administrative features but typically larger than cities,
        /// in countries that use such an additional layer in postal addressing (for example, prefectures in China).
        case district

        /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada
        /// or China.
        case region

        /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative
        /// status
        /// that has been given a designated country code under ISO 3166-1.
        case country
    }
}
