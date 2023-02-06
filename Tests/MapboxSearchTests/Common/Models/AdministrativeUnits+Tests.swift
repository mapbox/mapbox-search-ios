// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

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
        XCTAssertEqual(AdministrativeUnit.Japan.prefecture.rawValue, SearchQueryType.region)
        XCTAssertEqual(AdministrativeUnit.Japan.city.rawValue, SearchQueryType.place)
        XCTAssertEqual(AdministrativeUnit.Japan.oaza.rawValue, SearchQueryType.locality)
        XCTAssertEqual(AdministrativeUnit.Japan.chome.rawValue, SearchQueryType.neighborhood)
    }
}
