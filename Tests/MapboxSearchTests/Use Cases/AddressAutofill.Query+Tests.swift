// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class AddressAutofillQueryTests: XCTestCase {
    func testThatQueryIsNotInitializedWithIncorrectValue() {
        XCTAssertNil(AddressAutofill.Query(value: ""))
        XCTAssertNil(AddressAutofill.Query(value: "1"))
    }
    
    func testThatQueryIsInitializedWithCorrectValue() {
        let query = AddressAutofill.Query(value: "123")
        
        XCTAssertNotNil(query)
        XCTAssertEqual(query?.value, "123")
    }
}
