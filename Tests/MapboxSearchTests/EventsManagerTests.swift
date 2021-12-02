import XCTest
@testable import MapboxSearch
import CwlPreconditionTesting

class EventsManagerTests: XCTestCase {
    var telemetryStub: TelemetryManagerStub!
    var eventsManager: EventsManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        telemetryStub = TelemetryManagerStub()
        eventsManager = EventsManager(telemetry: telemetryStub)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        telemetryStub = nil
        eventsManager = nil
    }
    
    func testNativeTelemetryUsualEventPreparation() throws {
        let eventTemplate = """
                            {
                                "event": "stub-event",
                                "created": "2014-01-01T23:28:56.782Z",
                                "userAgent": "custom-user-agent",
                                "customField": "random-value"
                            }
                            """
        
        eventsManager.sendEvent(json: eventTemplate)
        
        XCTAssert(telemetryStub.reportedErrors.isEmpty)
        
        let event = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
        
        XCTAssertEqual(event.name, "stub-event")
        XCTAssertEqual(event.attributes.count, 1)
        XCTAssertEqual(event.attributes["customField"] as? String, "random-value")
    }
    
    func testSendAttributedEvent() throws {
        let attributes = ["created": "2014-01-01T23:28:56.782Z", "event": "test-event", "customField": "random"]
        eventsManager.sendEvent(.feedback, attributes: attributes, autoFlush: false)
        
        let event = try XCTUnwrap(telemetryStub.enqueuedEvents.last)
        
        XCTAssertEqual(event.name, EventsManager.Events.feedback.rawValue)
        XCTAssertEqual(event.attributes.count, 3)
        XCTAssertEqual(event.attributes["customField"] as? String, "random")
    }
    
    func testNativeTelemetryBrokenEvent() throws {
        #if !arch(x86_64)
        throw XCTSkip("Unsupported architecture")
        #else
        let assertionError = catchBadInstruction {
            self.eventsManager.sendEvent(json: "\"customField\": \"random-value\"")
        }
        XCTAssertNotNil(assertionError)
        
        XCTAssertEqual(telemetryStub.reportedErrors.first as NSError?, SearchError.incorrectEventTemplate as NSError)
        XCTAssert(telemetryStub.enqueuedEvents.isEmpty)
        #endif
    }
    
    func testNativeTelemetryHandlingErrors() throws {
        let error = NSError(domain: "myDomain", code: -28564, userInfo: ["key": "value17"])
        eventsManager.reportError(error)
        
        let reportedError = try XCTUnwrap(telemetryStub.reportedErrors.last as NSError?)
        XCTAssertEqual(error, reportedError)
    }
}
