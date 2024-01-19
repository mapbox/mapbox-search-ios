import Contacts
import Foundation

extension Discover {
    public struct Address {
        /// House number of the individual residential or business addresses.
        public let houseNumber: String?

        /// Street name of the individual residential or business addresses.
        public let street: String?

        /// Colloquial sub-city features often referred to in local parlance.
        /// Unlike locality features, these typically lack official status and may lack universally agreed-upon
        /// boundaries.
        public let neighborhood: String?

        /// Official sub-city features present in countries where such an additional administrative layer is used in
        /// postal addressing,
        /// or where such features are commonly referred to in local parlance.
        /// Examples include city districts in Brazil and Chile and arrondissements in France.
        public let locality: String?

        /// Postal codes used in country-specific national addressing systems.
        public let postcode: String?

        /// Typically these are cities, villages, municipalities, etc.
        /// They’re usually features used in postal addressing, and are suitable for display in ambient end-user
        /// applications
        /// where current-location context is needed (for example, in weather displays).
        public let place: String?

        /// Features that are smaller than top-level administrative features but typically larger than cities,
        /// in countries that use such an additional layer in postal addressing (for example, prefectures in China).
        public let district: String?

        /// Top-level sub-national administrative features, such as states in the United States or provinces in Canada
        /// or China.
        public let region: String?

        /// Generally recognized countries or, in some cases like Hong Kong, an area of quasi-national administrative
        /// status
        /// that has been given a designated country code under ISO 3166-1.
        public let country: String?

        /// The country code in ISO 3166-1.
        public let countryISO1: String?

        /// The country code and its country subdivision code in ISO 3166-2.
        public let countryISO2: String?

        init() {
            self.houseNumber = nil
            self.street = nil
            self.neighborhood = nil
            self.locality = nil
            self.postcode = nil
            self.place = nil
            self.district = nil
            self.region = nil
            self.country = nil
            self.countryISO1 = nil
            self.countryISO2 = nil
        }

        init(searchResult: SearchResult) {
            self.houseNumber = searchResult.address?.houseNumber
            self.street = searchResult.address?.street
            self.neighborhood = searchResult.address?.neighborhood
            self.locality = searchResult.address?.locality
            self.postcode = searchResult.address?.postcode
            self.place = searchResult.address?.place
            self.district = searchResult.address?.district
            self.region = searchResult.address?.region
            self.country = searchResult.address?.country
            self.countryISO1 = searchResult.metadata?["iso_3166_1"]
            self.countryISO2 = searchResult.metadata?["iso_3166_2"]
        }
    }
}

// MARK: - Contacts extension

extension Discover.Address {
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
}
