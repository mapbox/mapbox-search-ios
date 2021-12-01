@testable import MapboxSearch
import MapboxMobileEvents

class TelemetryManagerStub: TelemetryManager {
    var enqueuedEvents: [(name: String, attributes: [String: Any])] = []
    var reportedErrors: [Error] = []
    
    var accessToken: String!
    var userAgent: String!
    var hostSDKVersion: String!
    
    func initialize(withAccessToken accessToken: String, userAgentBase: String, hostSDKVersion: String) {
        self.accessToken = accessToken
        self.userAgent = userAgentBase
        self.hostSDKVersion = hostSDKVersion
    }
    
    func enqueueEvent(withName name: String, attributes: [String: Any]) {
        enqueuedEvents.append((name, attributes))
    }
    
    func reportError(_ eventsError: Error) -> MMEEvent {
        reportedErrors.append(eventsError)
        return MMEEvent()
    }
    func flush() {
        enqueuedEvents.removeAll()
    }
    
    var delegate: MMEEventsManagerDelegate?
}
