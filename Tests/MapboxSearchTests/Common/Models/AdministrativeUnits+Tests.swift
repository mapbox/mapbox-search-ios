@testable import MapboxSearch
import XCTest

final class AdministrativeUnitsTests: XCTestCase {
    func testCommonAdministrativeUnits() {
        XCTAssertEqual(AdministrativeUnit.address.rawValue, .address)
        XCTAssertEqual(AdministrativeUnit.country.rawValue, .country)
        XCTAssertEqual(AdministrativeUnit.region.rawValue, .region)
        XCTAssertEqual(AdministrativeUnit.postcode.rawValue, .postcode)
        XCTAssertEqual(AdministrativeUnit.district.rawValue, .district)
        XCTAssertEqual(AdministrativeUnit.place.rawValue, .place)
        XCTAssertEqual(AdministrativeUnit.locality.rawValue, .locality)
        XCTAssertEqual(AdministrativeUnit.neighborhood.rawValue, .neighborhood)
        XCTAssertEqual(AdministrativeUnit.street.rawValue, .street)
    }

    func testJapanAdministrativeUnits() {
        XCTAssertEqual(AdministrativeUnit.prefecture.rawValue, .region)
        XCTAssertEqual(AdministrativeUnit.city.rawValue, .place)
        XCTAssertEqual(AdministrativeUnit.oaza.rawValue, .locality)
        XCTAssertEqual(AdministrativeUnit.chome.rawValue, .neighborhood)
    }
}
