@testable import MapboxSearch
import XCTest

class CoreResultTypeTests: XCTestCase {
    func testMultipleAddressTypes() throws {
        XCTAssertTrue(CoreResultType.hasOnlyAddressSubtypes(types: CoreResultType.allAddressTypes))
    }

    func testMixedTypes() throws {
        XCTAssertFalse(CoreResultType.hasOnlyAddressSubtypes(types: CoreResultType.allAddressTypes + [.category]))
    }
}
