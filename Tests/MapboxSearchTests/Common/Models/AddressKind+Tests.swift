// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class AddressKindTests: XCTestCase {
    func testThatAddressKindIsInitializedCorrectlyFromCoreTypes() {
        let addressKinds = CoreResultType.allAddressTypes.compactMap(AddressKind.init(_:))
        
        XCTAssertEqual(CoreResultType.allAddressTypes.count, addressKinds.count)
    }
    
    func testRelatedAddressTypesFromCoreTypes() {
        let validAddressCheck: (CoreResultType, AddressKind) -> Void = { coreAddress, addressKind in
            let fromCore = AddressKind(coreAddress)
            
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
            let fromCore = AddressKind(coreAddress)
            
            XCTAssertNil(fromCore)
        }
        
        invalidAddressCheck(.unknown)
        invalidAddressCheck(.category)
        invalidAddressCheck(.userRecord)
        invalidAddressCheck(.query)
        invalidAddressCheck(.poi)
    }
}
