import Foundation

/// Report search error or any other to the Mapbox telemetry.
///
/// That will help us to investigate issues related to search and search quality.
public class EventsManager: NSObject {
    var userAgentName: String {
        "search-sdk-ios/\(mapboxSearchSDKVersion)"
    }

    enum Events: String {
        case feedback = "search.feedback"

        var version: String {
            switch self {
            case .feedback:
                return "2.3"
            }
        }
    }

    /// - Parameter json: EventTemplate from CoreSearchEngine
    func sendEvent(json: String) {
        // TODO: Analytics
    }

    func sendEvent(_ event: Events, attributes: [String: Any], autoFlush: Bool) {
        // TODO: Analytics
    }

    /// Report an error to Mapbox Search SDK.
    /// - Parameter error: any Mapbox Search SDK error.
    public func reportError(_ error: Error) {
        // TODO: Analytics
    }

    /// Report an error to Mapbox Search SDK.
    /// - Parameter error: any Mapbox Search SDK error.
    public func reportError(_ error: SearchError) {
        // TODO: Analytics
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
              var jsonObject = try? JSONSerialization.jsonObject(
                  with: jsonData,
                  options: [.mutableContainers]
              ) as? [String: Any],
              let eventName = jsonObject.removeValue(forKey: "event") as? String
        else {
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
            "userAgent": userAgentName,
        ]
    }
}
