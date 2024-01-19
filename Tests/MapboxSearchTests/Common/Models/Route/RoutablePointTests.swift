@testable import MapboxSearch
import XCTest

class RoutablePointTests: XCTestCase {
    func testRoutablePointInit() {
        let corePoint = CoreRoutablePoint(point: .sample1, name: "Test Point Name")
        let point = RoutablePoint(routablePoint: corePoint)

        XCTAssertEqual(point.name, "Test Point Name")
        XCTAssertEqual(point.point, .sample1)
    }
}
