import Foundation
import MapboxCommon_Private

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

    private let eventsService: EventsServiceProtocol

    override convenience init() {
        let options = EventsServerOptions(
            sdkInformation: SdkInformation.defaultInfo,
            deferredDeliveryServiceOptions: nil
        )
        let eventsService = EventsService.getOrCreate(for: options)
        self.init(eventsService: eventsService)
    }

    init(eventsService: EventsServiceProtocol) {
        self.eventsService = eventsService
        super.init()
    }

    func sendEvent(_ event: Events, attributes: [String: Any], autoFlush: Bool) {
        var commonEventAttributes = attributes
        commonEventAttributes["event"] = event.rawValue

        // This unhandled parameter must be removed to match the event scheme.
        commonEventAttributes.removeValue(forKey: "mapboxId")

        let commonEvent = Event(
            priority: autoFlush ? .immediate : .queued,
            attributes: commonEventAttributes,
            deferredOptions: nil
        )
        eventsService.sendEvent(for: commonEvent) { expected in
            if expected.isError() {
                _Logger.searchSDK
                    .error("Failed to send the event \(event.rawValue) due to error: \(expected.error.message)")
            } else if expected.isValue() {
                _Logger.searchSDK.debug("Sent the event \(event.rawValue)")
            }
        }
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

    /// json string from the core side populate the whole json suitable for the server.
    /// All the events, exept for the feedback event, are sent from the core side.
    /// - Parameter eventTemplate: feedbackEventTemplate from CoreSearchEngine
    func prepareEventTemplate(_ eventTemplate: String) throws -> [String: Any] {
        guard let jsonData = eventTemplate.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(
                  with: jsonData,
                  options: [.mutableContainers]
              ) as? [String: Any],
              let eventName = jsonObject["event"] as? String,
              !eventName.isEmpty
        else {
            reportError(SearchError.incorrectEventTemplate)
            throw SearchError.incorrectEventTemplate
        }

        return jsonObject
    }

    func prepareEventTemplate(for event: String) -> [String: Any] {
        return [
            "event": event,
            "created": ISO8601DateFormatter().string(from: Date()),
            "userAgent": userAgentName,
        ]
    }
}
