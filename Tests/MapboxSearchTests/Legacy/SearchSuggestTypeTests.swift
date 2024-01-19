import CwlPreconditionTesting
@testable import MapboxSearch
import XCTest

class SearchSuggestTypeTests: XCTestCase {
    func testAddressCaseAssociatedValues() throws {
        XCTAssertEqual(
            SearchSuggestType.address(subtypes: [.country, .place, .street]).addressSubtypes,
            [.country, .place, .street]
        )
    }

    func testPOICaseMissingAssociatedAddressValues() {
        XCTAssertNil(SearchSuggestType.POI.addressSubtypes)
    }

    func testSearchSuggestTypePOIInit() {
        XCTAssertEqual(SearchSuggestType(resultType: SearchResultType.POI), .POI)
    }

    func testSearchSuggestTypeAddressInit() throws {
        let addressResultType = try XCTUnwrap(SearchResultType(coreResultTypes: CoreResultType.allAddressTypes))
        XCTAssertEqual(
            SearchSuggestType(resultType: addressResultType).addressSubtypes?.count,
            CoreResultType.allAddressTypes.count
        )
    }
}

// MARK: Codable tests

extension SearchSuggestTypeTests {
    func testPOICodableConversion() throws {
        let object = SearchSuggestType.POI

        let encoder = JSONEncoder()
        let data = try encoder.encode(object)

        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(SearchSuggestType.self, from: data)

        XCTAssertEqual(decodedObject, object)
    }

    func testCategoryCodableConversion() throws {
        let object = SearchSuggestType.category

        let encoder = JSONEncoder()
        let data = try encoder.encode(object)

        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(SearchSuggestType.self, from: data)

        XCTAssertEqual(decodedObject, object)
    }

    func testQueryCodableConversion() throws {
        let object = SearchSuggestType.query

        let encoder = JSONEncoder()
        let data = try encoder.encode(object)

        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(SearchSuggestType.self, from: data)

        XCTAssertEqual(decodedObject, object)
    }

    func testAddressCodableConversion() throws {
        let object = SearchSuggestType.address(subtypes: [.place, .country, .postcode])

        let encoder = JSONEncoder()
        let data = try encoder.encode(object)

        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(SearchSuggestType.self, from: data)

        XCTAssertEqual(decodedObject, object)
    }

    func testDecodableWithCorruptedData() throws {
        let data = "{}".data(using: .utf8)!

        let assertionError = catchBadInstruction {
            let decoder = JSONDecoder()
            // swiftlint:disable:next force_try
            _ = try! decoder.decode(SearchSuggestType.self, from: data)
        }
        XCTAssertNotNil(assertionError)
    }
}
