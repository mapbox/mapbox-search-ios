@testable import MapboxSearch
import XCTest

final class SearchAddressTypeTests: XCTestCase {
    func testThatSearchAddressTypeIsInitializedCorrectlyFromCoreTypes() {
        let addressKinds = CoreResultType.allAddressTypes.compactMap(SearchAddressType.init(_:))

        XCTAssertEqual(CoreResultType.allAddressTypes.count, addressKinds.count)
    }

    func testRelatedAddressTypesFromCoreTypes() {
        let validAddressCheck: (CoreResultType, SearchAddressType) -> Void = { coreAddress, addressKind in
            let fromCore = SearchAddressType(coreAddress)

            XCTAssertNotNil(fromCore)
            XCTAssertEqual(addressKind, fromCore)
        }

        validAddressCheck(.address, .address)
        validAddressCheck(.place, .place)
        validAddressCheck(.street, .street)
        validAddressCheck(.postcode, .postcode)
        validAddressCheck(.country, .country)
        validAddressCheck(.region, .region)
        validAddressCheck(.district, .district)
        validAddressCheck(.locality, .locality)
        validAddressCheck(.neighborhood, .neighborhood)
    }

    func testUnrelatedAddressTypesFromCoreTypes() {
        let invalidAddressCheck: (CoreResultType) -> Void = { coreAddress in
            let fromCore = SearchAddressType(coreAddress)

            XCTAssertNil(fromCore)
        }

        invalidAddressCheck(.unknown)
        invalidAddressCheck(.category)
        invalidAddressCheck(.userRecord)
        invalidAddressCheck(.query)
        invalidAddressCheck(.poi)
    }
}
