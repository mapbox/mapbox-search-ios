import Foundation
@testable import MapboxSearch
import XCTest

class RouteTests: XCTestCase {
    func testRouteCoordinatesConversion() {
        let route = Route(coordinates: [.sample1, .sample2])

        XCTAssertEqual(route.coordinates, [.sample1, .sample2])
        XCTAssertEqual(route.coordinatesCodable, [.sample1, .sample2])
    }

    func testEqualRoutes() {
        let route1 = Route(coordinates: [.sample1, .sample2])
        let route2 = Route(coordinates: [.sample1, .sample2])

        XCTAssertEqual(route1, route2)
    }

    func testNonEqualRoutes() {
        let route1 = Route(coordinates: [.sample1, .sample2])
        let route2 = Route(coordinates: [.sample2, .sample1])

        XCTAssertNotEqual(route1, route2)
    }
}
