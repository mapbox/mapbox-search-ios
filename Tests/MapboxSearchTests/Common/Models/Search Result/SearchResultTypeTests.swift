import CwlPreconditionTesting
@testable import MapboxSearch
import XCTest

class SearchResultTypeTests: XCTestCase {
    func testAddressCaseAssociatedValues() throws {
        XCTAssertEqual(
            SearchResultType.address(subtypes: [.country, .place, .street]).addressSubtypes,
            [.country, .place, .street]
        )
    }

    func testPOICaseMissingAssociatedAddressValues() {
        XCTAssertNil(SearchResultType.POI.addressSubtypes)
    }

    func testPOIInit() {
        XCTAssertEqual(SearchResultType(coreResultTypes: [.poi]), .POI)
    }

    func testMixedPOIInit() throws {
        let assertionError = catchBadInstruction {
            _ = SearchResultType(coreResultTypes: [.poi, .place])
        }
        XCTAssertNotNil(assertionError)
    }

    func testAddressInit() {
        XCTAssertEqual(
            SearchResultType(coreResultTypes: [.place, .country])?.addressSubtypes,
            [.place, .country]
        )
    }

    func testAddressWithPOIInit() throws {
        let assertionError = catchBadInstruction {
            _ = SearchResultType(coreResultTypes: [.place, .unknown])
        }
        XCTAssertNotNil(assertionError)
    }

    func testInappropriateTypesInInit() {
        XCTAssertNil(SearchResultType(coreResultTypes: [.category]))
    }
}

// MARK: Codable tests

extension SearchResultTypeTests {
    func testPOICodableConversion() throws {
        let object = SearchResultType.POI

        let encoder = JSONEncoder()
        let data = try encoder.encode(object)

        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(SearchResultType.self, from: data)

        XCTAssertEqual(decodedObject, object)
    }

    func testAddressCodableConversion() throws {
        let object = try XCTUnwrap(SearchResultType(coreResultTypes: CoreResultType.allAddressTypes))

        XCTAssertEqual(object.addressSubtypes?.count, CoreResultType.allAddressTypes.count)

        let encoder = JSONEncoder()
        let data = try encoder.encode(object)

        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(SearchResultType.self, from: data)

        XCTAssertEqual(decodedObject, object)
    }

    func testDecodableWithCorruptedData() throws {
        let fakeObject = SearchRequestOptions(query: "query", proximity: .sample1)

        let encoder = JSONEncoder()
        let data = try encoder.encode(fakeObject)

        let assertionError = catchBadInstruction {
            let decoder = JSONDecoder()
            // swiftlint:disable:next force_try
            _ = try! decoder.decode(SearchResultType.self, from: data)
        }
        XCTAssertNotNil(assertionError)
    }
}
