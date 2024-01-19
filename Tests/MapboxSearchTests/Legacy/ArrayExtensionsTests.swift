@testable import MapboxSearch
import XCTest

class ArrayExtensionsTests: XCTestCase {
    func testRemoveSingleDuplicate() throws {
        let input = [1, 2, 2, 3]
        let output = input.removingDuplicates()

        XCTAssertEqual(output, [1, 2, 3])
    }

    func testRemoveMultipleDuplicate() throws {
        let input = [1, 2, 2, 2, 3, 3, 3, 1]
        let output = input.removingDuplicates()

        XCTAssertEqual(output, [1, 2, 3])
    }

    func testNoDuplicates() {
        let input = [1, 2, 3]
        let output = input.removingDuplicates()

        XCTAssertEqual(output, [1, 2, 3])
    }
}
