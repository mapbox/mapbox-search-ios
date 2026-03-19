@testable import MapboxSearch
import XCTest

final class QueryTypeTests: XCTestCase {
    func testRawValues() {
        XCTAssertEqual(QueryType.country.rawValue, "country")
        XCTAssertEqual(QueryType.region.rawValue, "region")
        XCTAssertEqual(QueryType.postcode.rawValue, "postcode")
        XCTAssertEqual(QueryType.district.rawValue, "district")
        XCTAssertEqual(QueryType.place.rawValue, "place")
        XCTAssertEqual(QueryType.locality.rawValue, "locality")
        XCTAssertEqual(QueryType.neighborhood.rawValue, "neighborhood")
        XCTAssertEqual(QueryType.address.rawValue, "address")
        XCTAssertEqual(QueryType.poi.rawValue, "poi")
        XCTAssertEqual(QueryType.street.rawValue, "street")
        XCTAssertEqual(QueryType.category.rawValue, "category")
        XCTAssertEqual(QueryType.brand.rawValue, "brand")
    }

    func testToCoreTypesConversions() {
        XCTAssertEqual(QueryType.country.coreValue, .country)
        XCTAssertEqual(QueryType.region.coreValue, .region)
        XCTAssertEqual(QueryType.postcode.coreValue, .postcode)
        XCTAssertEqual(QueryType.district.coreValue, .district)
        XCTAssertEqual(QueryType.place.coreValue, .place)
        XCTAssertEqual(QueryType.locality.coreValue, .locality)
        XCTAssertEqual(QueryType.neighborhood.coreValue, .neighborhood)
        XCTAssertEqual(QueryType.address.coreValue, .address)
        XCTAssertEqual(QueryType.poi.coreValue, .poi)
        XCTAssertEqual(QueryType.street.coreValue, .street)
        XCTAssertEqual(QueryType.category.coreValue, .category)
        XCTAssertEqual(QueryType.brand.coreValue, .brand)
    }

    func testFromCoreTypesConversions() {
        XCTAssertEqual(QueryType.fromCoreValue(.country), .country)
        XCTAssertEqual(QueryType.fromCoreValue(.region), .region)
        XCTAssertEqual(QueryType.fromCoreValue(.postcode), .postcode)
        XCTAssertEqual(QueryType.fromCoreValue(.district), .district)
        XCTAssertEqual(QueryType.fromCoreValue(.place), .place)
        XCTAssertEqual(QueryType.fromCoreValue(.locality), .locality)
        XCTAssertEqual(QueryType.fromCoreValue(.neighborhood), .neighborhood)
        XCTAssertEqual(QueryType.fromCoreValue(.address), .address)
        XCTAssertEqual(QueryType.fromCoreValue(.poi), .poi)
        XCTAssertEqual(QueryType.fromCoreValue(.street), .street)
        XCTAssertEqual(QueryType.fromCoreValue(.category), .category)
        XCTAssertEqual(QueryType.fromCoreValue(.brand), .brand)
    }

    @available(*, deprecated)
    func testSearchQueryTypeConversions() {
        XCTAssertEqual(SearchQueryType.country.coreValue, .country)
        XCTAssertEqual(SearchQueryType.region.coreValue, .region)
        XCTAssertEqual(SearchQueryType.postcode.coreValue, .postcode)
        XCTAssertEqual(SearchQueryType.district.coreValue, .district)
        XCTAssertEqual(SearchQueryType.place.coreValue, .place)
        XCTAssertEqual(SearchQueryType.locality.coreValue, .locality)
        XCTAssertEqual(SearchQueryType.neighborhood.coreValue, .neighborhood)
        XCTAssertEqual(SearchQueryType.address.coreValue, .address)
        XCTAssertEqual(SearchQueryType.poi.coreValue, .poi)
        XCTAssertEqual(SearchQueryType.street.coreValue, .street)
        XCTAssertEqual(SearchQueryType.category.coreValue, .category)
    }

    @available(*, deprecated)
    func testSearchQueryArrayTypeConversions() {
        let array: [SearchQueryType] = [
            .country,
            .region,
            .postcode,
            .district,
            .place,
            .locality,
            .neighborhood,
            .address,
            .poi,
            .street,
            .category,
        ]
        let expectedArray: [QueryType] = [
            .country,
            .region,
            .postcode,
            .district,
            .place,
            .locality,
            .neighborhood,
            .address,
            .poi,
            .street,
            .category,
        ]
        XCTAssertEqual(array.asQueryTypes, expectedArray)
    }

    @available(*, deprecated)
    func testSearchQueryArrayReverseTypeConversions() {
        let array: [QueryType] = [
            .brand,
            .country,
            .region,
            .postcode,
            .district,
            .place,
            .locality,
            .neighborhood,
            .address,
            .poi,
            .street,
            .category,
        ]
        let expectedArray: [SearchQueryType] = [
            .poi,
            .country,
            .region,
            .postcode,
            .district,
            .place,
            .locality,
            .neighborhood,
            .address,
            .poi,
            .street,
            .category,
        ]
        XCTAssertEqual(array.asSearchQueryTypes, expectedArray, "Skipping brand type in conversion")
    }
}
