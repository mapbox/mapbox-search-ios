// Copyright © 2023 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class EventsManagerTests: XCTestCase {

    var eventsManager: EventsManager!

    override func setUp() {
        super.setUp()

        eventsManager = EventsManager()
    }

    func testUserAgent() {
        XCTAssertEqual(eventsManager.userAgentName, "search-sdk-ios/\(mapboxSearchSDKVersion)")
    }

    func testPrepareEventTemplate() {
        let event = eventsManager.prepareEventTemplate(for: "templateEvent")
        XCTAssertEqual(event["userAgent"] as? String, "search-sdk-ios/\(mapboxSearchSDKVersion)")
    }
}
