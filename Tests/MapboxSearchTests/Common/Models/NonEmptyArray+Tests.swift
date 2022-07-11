// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

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
