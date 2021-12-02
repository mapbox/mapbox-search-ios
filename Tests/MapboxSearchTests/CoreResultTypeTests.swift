import XCTest
@testable import MapboxSearch

class CoreResultTypeTests: XCTestCase {
    func testMultipleAddressTypes() throws {
        XCTAssertTrue(CoreResultType.hasOnlyAddressSubtypes(types: CoreResultType.allAddressTypes))
    }

    func testMixedTypes() throws {
        XCTAssertFalse(CoreResultType.hasOnlyAddressSubtypes(types: CoreResultType.allAddressTypes + [.category]))
    }
}
