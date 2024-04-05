@testable import MapboxSearch

extension CoreAddress {
    override open func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? CoreAddress {
            return houseNumber == rhs.houseNumber &&
                street == rhs.street &&
                neighborhood == rhs.neighborhood &&
                locality == rhs.locality &&
                postcode == rhs.postcode &&
                place == rhs.place &&
                district == rhs.district &&
                region == rhs.region &&
                country == rhs.country
        } else {
            return false
        }
    }
}
