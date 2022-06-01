import Foundation
import MapboxMobileEvents

/// Report search error or any other to the Mapbox telemetry.
///
/// That will help us to investigate issues related to search and search quality.
public class EventsManager: NSObject {
    let userAgentName = "search-sdk-ios"
    
    enum Events: String {
        case feedback = "search.feedback"
        
        var version: String {
            switch self {
            case .feedback:
                return "2.3"
            }
        }
    }
    
    let telemetry: TelemetryManager
    
    init(telemetry: TelemetryManager) {
        self.telemetry = telemetry
        super.init()
        self.telemetry.delegate = self
    }
    
    func initialize(accessToken: String) {
        telemetry.initialize(withAccessToken: accessToken,
                             userAgentBase: userAgentName,
                             hostSDKVersion: mapboxSearchSDKVersion)
    }
    
    /// - Parameter json: EventTemplate from CoreSearchEngine
    func sendEvent(json: String) {
        guard let event = try? prepareEventTemplate(json) else {
            _Logger.searchSDK.debug("Unable to send Telemetry event", category: .telemetry)
            assertionFailure("incorrect event format")
            return
        }
        telemetry.enqueueEvent(withName: event.name, attributes: event.attributes)
    }
    
    func sendEvent(_ event: Events, attributes: [String: Any], autoFlush: Bool) {
        telemetry.enqueueEvent(withName: event.rawValue, attributes: attributes)
        if autoFlush {
            telemetry.flush()
        }
    }
    
    /// Report an error to Mapbox Search SDK.
    /// - Parameter error: any Mapbox Search SDK error.
    public func reportError(_ error: Error) {
        telemetry.reportError(error)
    }
    
    /// Report an error to Mapbox Search SDK.
    /// - Parameter error: any Mapbox Search SDK error.
    public func reportError(_ error: SearchError) {
        telemetry.reportError(error)
    }
    
    /// json string from the core side populate the whole json suitable for the server
    /// Unfortunately, telemetry SDK doesn't support such kind of event
    /// Thats why we adopt the raw json to the telemetry-specific API:
    /// eventName + set of event attributes
    /// We also have a set of default attributes created automatically: `created` and `userAgent`
    /// Telemetry SDK is capable to set them on their own
    /// - Parameter eventTemplate: feedbackEventTemplate from CoreSearchEngine
    func prepareEventTemplate(_ eventTemplate: String) throws -> (name: String, attributes: [String: Any]) {
        guard let jsonData = eventTemplate.data(using: .utf8),
              var jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [.mutableContainers]) as? [String: Any],
              let eventName = jsonObject.removeValue(forKey: "event") as? String else {
            reportError(SearchError.incorrectEventTemplate)
            throw SearchError.incorrectEventTemplate
        }
        jsonObject.removeValue(forKey: "created")
        jsonObject.removeValue(forKey: "userAgent")
        
        return (eventName, jsonObject)
    }
    
    func prepareEventTemplate(for event: String) -> [String: Any] {
        return [
            "event": event,
            "created": ISO8601DateFormatter().string(from: Date()),
            "userAgent": userAgentName
        ]
    }
}

extension EventsManager: MMEEventsManagerDelegate {
    /// Report internal errors
    public func eventsManager(_ eventsManager: MMEEventsManager, didEncounterError error: Error) {
        _Logger.searchSDK.debug(error.localizedDescription, category: .telemetry)
    }
    
    /// Provide debug logs for telemetry communication for ``LogCategory/telemetry``
    public func eventsManager(_ eventsManager: MMEEventsManager, didSend events: [MMEEvent]) {
        _Logger.searchSDK.debug("Telemetry Events \(events.count) send", category: .telemetry)
    }
}
