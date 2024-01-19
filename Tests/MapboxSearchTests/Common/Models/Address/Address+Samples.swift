@testable import MapboxSearch

extension Address {
    static let fullAddress = Address(
        houseNumber: "$houseNumber",
        street: "$street",
        neighborhood: "$neighborhood",
        locality: "$locality",
        postcode: "$postcode",
        place: "$place",
        district: "$district",
        region: "$region",
        country: "$country"
    )

    static let mapboxDCOffice = Address(
        houseNumber: "740",
        street: "15th St NW",
        neighborhood: "Downtown",
        locality: nil,
        postcode: "20005",
        place: "Washington",
        district: nil,
        region: "District of Columbia",
        country: "United States"
    )

    static let emptyAddress = Address.empty
}
