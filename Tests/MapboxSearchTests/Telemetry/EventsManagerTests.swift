import MapboxCommon_Private
@testable import MapboxSearch
import XCTest

final class EventsServiceMock: EventsServiceProtocol {
    var events: [Event] = []

    func sendEvent(for event: Event, callback: EventsServiceResponseCallback?) {
        events.append(event)
        callback?(.init(value: NSNull()))
    }
}

final class EventsManagerTests: XCTestCase {
    var eventsManager: EventsManager!
    var eventsService: EventsServiceMock!

    override func setUp() {
        super.setUp()

        eventsService = EventsServiceMock()
        eventsManager = EventsManager(eventsService: eventsService)
    }

    func testUserAgent() {
        XCTAssertEqual(eventsManager.userAgentName, "search-sdk-ios/\(mapboxSearchSDKVersion)")
    }

    func testPrepareEventTemplate() {
        let event = eventsManager.prepareEventTemplate(for: "templateEvent")
        XCTAssertEqual(event["userAgent"] as? String, "search-sdk-ios/\(mapboxSearchSDKVersion)")
    }

    func testSendEvent() {
        let attributes = ["a": "b", "mapboxId": "value"]
        let expectedAttributes = ["a": "b", "event": "search.feedback"]

        eventsManager.sendEvent(.feedback, attributes: attributes, autoFlush: true)
        let sentEvent1 = eventsService.events[0]
        XCTAssertEqual(sentEvent1.priority, .immediate)
        XCTAssertEqual(sentEvent1.attributes as? [String: String], expectedAttributes)
        XCTAssertNil(sentEvent1.deferredOptions)

        eventsManager.sendEvent(.feedback, attributes: attributes, autoFlush: false)
        let sentEvent2 = eventsService.events[1]
        XCTAssertEqual(sentEvent2.priority, .queued)
    }
}
