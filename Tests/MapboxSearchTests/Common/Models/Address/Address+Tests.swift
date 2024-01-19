@testable import MapboxSearch
import XCTest

class AddressFormatterTests: XCTestCase {
    var address: Address {
        .fullAddress
    }

    func testShortStyle() {
        XCTAssertEqual(address.formattedAddress(style: .short), "$houseNumber $street")
    }

    func testMediumStyleForNonRegionBasedCountry() {
        XCTAssertEqual(address.formattedAddress(style: .medium), "$houseNumber $street, $place")
    }

    func testMediumStyleForRegionBasedCountryLikeUSA() {
        var usaAddress = address
        usaAddress.country = "United States of America"
        XCTAssertEqual(usaAddress.formattedAddress(style: .medium), "$houseNumber $street, $place, $region")
    }

    func testLongStyle() {
        XCTAssertEqual(
            address.formattedAddress(style: .long),
            "$houseNumber $street, $neighborhood, $locality, $place, $district, $region, $country"
        )
    }

    func testFullStyle() {
        XCTAssertEqual(
            address.formattedAddress(style: .full),
            "$houseNumber $street, $neighborhood, $locality, $place, $district, $region, $country, $postcode"
        )
    }

    func testLonelyHouseNumberStyle() {
        XCTAssertEqual(address.formattedAddress(style: .custom(components: [\.houseNumber])), "$houseNumber")
    }

    func testCustomFormatForHouseNumberAndStreet() {
        XCTAssertEqual(
            address.formattedAddress(style: .custom(components: [\.houseNumber, \.street])),
            "$houseNumber $street"
        )
    }

    func testCustomFormatForStreetAndRegion() {
        XCTAssertEqual(address.formattedAddress(style: .custom(components: [\.street, \.region])), "$street, $region")
    }

    func testEmptyAddress() {
        let address = Address()

        XCTAssertNil(address.formattedAddress(style: .full))
    }

    func testFullPostalAddress() {
        let postal = address.postalAddress
        XCTAssertEqual(postal.city, "$place")
        XCTAssertEqual(postal.street, "$houseNumber $street")
        XCTAssertEqual(postal.subLocality, "$neighborhood")
        XCTAssertEqual(postal.postalCode, "$postcode")
        XCTAssertEqual(postal.country, "$country")
        XCTAssertEqual(postal.state, "$region")
    }

    func testEmptyPostalAddress() {
        let postal = Address().postalAddress

        XCTAssertEqual(postal.city, "")
        XCTAssertEqual(postal.street, "")
        XCTAssertEqual(postal.subLocality, "")
        XCTAssertEqual(postal.postalCode, "")
        XCTAssertEqual(postal.country, "")
        XCTAssertEqual(postal.state, "")
    }

    func testConversionToCoreAddress() {
        let coreAddress = address.coreAddress()

        XCTAssertEqual(coreAddress.houseNumber, address.houseNumber)
        XCTAssertEqual(coreAddress.street, address.street)
        XCTAssertEqual(coreAddress.neighborhood, address.neighborhood)
        XCTAssertEqual(coreAddress.locality, address.locality)
        XCTAssertEqual(coreAddress.postcode, address.postcode)
        XCTAssertEqual(coreAddress.place, address.place)
        XCTAssertEqual(coreAddress.district, address.district)
        XCTAssertEqual(coreAddress.region, address.searchAddressRegion?.toCore())
        XCTAssertEqual(coreAddress.country, address.searchAddressCountry?.toCore())
    }

    func testEmptyCoreAddressConversion() {
        let coreAddress = CoreAddress(
            houseNumber: "",
            street: "",
            neighborhood: "",
            locality: "",
            postcode: "",
            place: "",
            district: "",
            region: nil,
            country: nil
        )
        let address = Address(coreAddress: coreAddress)

        XCTAssertNil(address.houseNumber)
        XCTAssertNil(address.street)
        XCTAssertNil(address.neighborhood)
        XCTAssertNil(address.locality)
        XCTAssertNil(address.postcode)
        XCTAssertNil(address.place)
        XCTAssertNil(address.district)
        XCTAssertNil(address.region)
        XCTAssertNil(address.country)
    }
}
