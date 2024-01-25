@testable import MapboxSearch
import XCTest

class SearchNavigationProfileTests: XCTestCase {
    func testDrivingProfile() {
        XCTAssertEqual(SearchNavigationProfile.driving.string, "driving")
    }

    func testCyclingProfile() {
        XCTAssertEqual(SearchNavigationProfile.cycling.string, "cycling")
    }

    func testWalkingProfile() {
        XCTAssertEqual(SearchNavigationProfile.walking.string, "walking")
    }

    func testCustomProfile() {
        XCTAssertEqual(SearchNavigationProfile.custom("custom navigation profile").string, "custom navigation profile")
    }
}
