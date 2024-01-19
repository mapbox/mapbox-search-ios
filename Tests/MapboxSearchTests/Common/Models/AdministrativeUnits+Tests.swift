@testable import MapboxSearch
import XCTest

final class AdministrativeUnitsTests: XCTestCase {
    func testCommonAdministrativeUnits() {
        XCTAssertEqual(AdministrativeUnit.address.rawValue, SearchQueryType.address)
        XCTAssertEqual(AdministrativeUnit.country.rawValue, SearchQueryType.country)
        XCTAssertEqual(AdministrativeUnit.region.rawValue, SearchQueryType.region)
        XCTAssertEqual(AdministrativeUnit.postcode.rawValue, SearchQueryType.postcode)
        XCTAssertEqual(AdministrativeUnit.district.rawValue, SearchQueryType.district)
        XCTAssertEqual(AdministrativeUnit.place.rawValue, SearchQueryType.place)
        XCTAssertEqual(AdministrativeUnit.locality.rawValue, SearchQueryType.locality)
        XCTAssertEqual(AdministrativeUnit.neighborhood.rawValue, SearchQueryType.neighborhood)
        XCTAssertEqual(AdministrativeUnit.street.rawValue, SearchQueryType.street)
    }

    func testJapanAdministrativeUnits() {
        XCTAssertEqual(AdministrativeUnit.prefecture.rawValue, SearchQueryType.region)
        XCTAssertEqual(AdministrativeUnit.city.rawValue, SearchQueryType.place)
        XCTAssertEqual(AdministrativeUnit.oaza.rawValue, SearchQueryType.locality)
        XCTAssertEqual(AdministrativeUnit.chome.rawValue, SearchQueryType.neighborhood)
    }
}
