@testable import MapboxSearch
import XCTest

final class NonEmptyArrayTests: XCTestCase {
    func testThatArrayIsInitializedCorrectly() {
        let first = "first"
        let others = ["second", "third"]

        let array = NonEmptyArray(first: first, others: others)

        XCTAssertEqual(array.all.count, 3)
        XCTAssertEqual(array.first, first)
        XCTAssertEqual(array.others, others)
    }
}
