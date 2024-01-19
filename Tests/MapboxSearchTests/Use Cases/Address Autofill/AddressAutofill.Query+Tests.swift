@testable import MapboxSearch
import XCTest

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
