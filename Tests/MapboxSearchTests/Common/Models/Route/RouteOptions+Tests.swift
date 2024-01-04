import XCTest
import CoreLocation
@testable import MapboxSearch

class RouteOptionsTests: XCTestCase {
    func testTimeDeviation() {
        let options = RouteOptions(route: .sample1, time: 7 * 60)

        XCTAssertEqual(options.deviation.time, 420)
        XCTAssertEqual(options.route, .sample1)
    }
}
