import MapboxMobileEvents

protocol TelemetryManager: AnyObject {
    func initialize(withAccessToken accessToken: String, userAgentBase: String, hostSDKVersion: String)
    func enqueueEvent(withName name: String, attributes: [String: Any])
    func flush()
    
    @discardableResult
    func reportError(_ eventsError: Error) -> MMEEvent
    
    var delegate: MMEEventsManagerDelegate? { get set }
}

extension MMEEventsManager: TelemetryManager { }
