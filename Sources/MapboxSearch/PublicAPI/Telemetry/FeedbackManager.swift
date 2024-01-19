import Foundation

protocol FeedbackManagerDelegate: AnyObject {
    var locationProviderWrapper: WrapperLocationProvider? { get }
    var engine: CoreSearchEngineProtocol { get }
}

/// Profile feedback or build custom events for Mapbox Telemetry
public class FeedbackManager {
    weak var delegate: FeedbackManagerDelegate?
    let eventsManager: EventsManager

    let attributePlaceholder = "<Not available>"

    init(eventsManager: EventsManager) {
        self.eventsManager = eventsManager
    }

    func buildAttributes(_ attributes: inout [String: Any], feedbackAttributes: FeedbackEvent.Attributes) {
        // Mandatory field set -1
        attributes["resultIndex"] = -1
        attributes["queryString"] = attributePlaceholder
        attributes["resultId"] = feedbackAttributes.id
        attributes["selectedItemName"] = feedbackAttributes.name

        if let coordinate = feedbackAttributes.coordinate {
            attributes["resultCoordinates"] = [coordinate.longitude, coordinate.latitude]
        }
    }

    func buildAttributes(
        _ attributes: inout [String: Any],
        response: CoreSearchResponseProtocol,
        result: CoreSearchResultProtocol?,
        isReproducible: Bool
    ) {
        // Response parameters
        attributes["queryString"] = response.request.query
        attributes["country"] = response.request.options.countries
        attributes["fuzzyMatch"] = response.request.options.fuzzyMatch?.boolValue
        attributes["limit"] = response.request.options.limit?.intValue
        attributes["types"] = response.request.options.types?
            .map { (CoreResultType(rawValue: $0.intValue) ?? .unknown).stringValue }
        attributes["sessionIdentifier"] = response.request.sessionID

        // `searchResultsJSON` required for `cant find` and `suggestion feedbacks`.
        // Single, resolved search result don't need it.
        if case .success(let results) = response.result {
            if results.count > 1 || result == nil {
                attributes["searchResultsJSON"] = buildSearchResultsJSON(
                    results: results,
                    isReproducible: isReproducible
                )
            }
        }

        if let bbox = response.request.options.bbox {
            attributes["bbox"] = [
                bbox.min.longitude, bbox.min.latitude,
                bbox.max.longitude, bbox.max.latitude,
            ]
        }

        if let proximity = response.request.options.proximity {
            attributes["proximity"] = [proximity.coordinate.longitude, proximity.coordinate.latitude]
        }

        attributes["responseUuid"] = response.responseUUID

        // Result parameters
        // Mandatory field set -1 if no data available
        attributes["resultIndex"] = result?.serverIndex ?? -1
        // Mandatory field setting placeholder if no data available
        attributes["selectedItemName"] = result?.names.first ?? attributePlaceholder
        attributes["language"] = result?.languages
        attributes["resultId"] = result?.id ?? attributePlaceholder

        if let center = result?.center {
            attributes["resultCoordinates"] = [center.coordinate.longitude, center.coordinate.latitude]
        }
    }

    func buildSearchResultsJSON(results: [CoreSearchResult], isReproducible: Bool) -> String? {
        guard results.isEmpty == false else {
            return nil
        }

        var root = [String: Any]()

        var searchResults = [[String: Any]]()

        for result in results {
            var attributes = [String: Any]()

            attributes["name"] = result.names.first
            attributes["address"] = result.addressDescription
            attributes["id"] = result.id
            attributes["language"] = result.languages
            attributes["result_type"] = result.resultTypes.map(\.stringValue)
            attributes["external_ids"] = result.externalIDs
            attributes["category"] = result.categories

            if let center = result.center {
                attributes["coordinates"] = [center.coordinate.longitude, center.coordinate.latitude]
            }

            searchResults.append(attributes)
        }
        root["results"] = searchResults
        root["multiStepSearch"] = !isReproducible

        let searchResultsJSON = (try? JSONSerialization.data(withJSONObject: root, options: [])).flatMap { String(
            data: $0,
            encoding: .utf8
        ) }
        return searchResultsJSON
    }

    func buildFeedbackAttributes(_ template: [String: Any], event: FeedbackEvent) throws -> [String: Any] {
        var attributes = template

        switch event.type {
        case .missingResult(let response):
            buildAttributes(&attributes, response: response, result: nil, isReproducible: event.isReproducible)

        case .coreResult(let response, let result):
            buildAttributes(&attributes, response: response, result: result, isReproducible: event.isReproducible)

        case .userRecord(let record):
            buildAttributes(&attributes, feedbackAttributes: FeedbackEvent.Attributes(record: record))

        case .suggestion(let record):
            buildAttributes(&attributes, feedbackAttributes: FeedbackEvent.Attributes(record: record))

        case .searchResult(let record):
            buildAttributes(&attributes, feedbackAttributes: FeedbackEvent.Attributes(record: record))
        }

        // Setting schema with version is required, otherwise telemetry will use v2.0 event version
        attributes["schema"] = "\(EventsManager.Events.feedback.rawValue)-\(EventsManager.Events.feedback.version)"

        // v2.0
        attributes["feedbackReason"] = event.reason ?? attributePlaceholder
        attributes["feedbackText"] = event.text

        attributes["keyboardLocale"] = event.keyboardLocale
        attributes["orientation"] = event.deviceOrientation

        if let viewport = event.viewPort {
            attributes["mapZoom"] = viewport.mapZoom()
            attributes["mapCenterLatitude"] = (viewport.max.latitude + viewport.min.latitude) / 2.0
            attributes["mapCenterLongitude"] = (viewport.max.longitude + viewport.min.longitude) / 2.0
        }

        // v2.1
        attributes["screenshot"] = event.screenshotData?.base64EncodedString()
        attributes["feedbackId"] = UUID().uuidString

#if DEBUG
        attributes["isTest"] = true
#endif

        // v2.2
        attributes["appMetadata"] = event.metadata.dictionary

        return attributes
    }

    func sendFeedback(attributes: [String: Any], autoFlush: Bool) {
        eventsManager.sendEvent(.feedback, attributes: attributes, autoFlush: autoFlush)
    }

    func buildTemplate(
        event: FeedbackEvent,
        completion: @escaping ([String: Any]) -> Void
    ) throws {
        guard let delegate else {
            assertionFailure("Delegate with Engine is required")
            _Logger.searchSDK.debug("Cant build FeedbackEvent, wouldn't send", category: .telemetry)
            throw SearchError.incorrectEventTemplate
        }

        switch event.type {
        case .missingResult(let response):
            try delegate.engine.makeFeedbackEvent(
                request: response.request,
                result: nil,
                callback: { [eventsManager] eventTemplateName in
                    do {
                        let attributes = try eventsManager.prepareEventTemplate(
                            eventTemplateName
                        ).attributes

                        completion(attributes)
                    } catch {
                        _Logger.searchSDK.error(
                            "Failed to prepare event template, error: \(error.localizedDescription)"
                        )
                    }
                }
            )

        case .coreResult(let response, let result):
            try delegate.engine.makeFeedbackEvent(
                request: response.request,
                result: result,
                callback: { [eventsManager] eventTemplateName in
                    do {
                        let attributes = try eventsManager.prepareEventTemplate(
                            eventTemplateName
                        ).attributes

                        completion(attributes)
                    } catch {
                        _Logger.searchSDK.error(
                            "Failed to prepare event template, error: \(error.localizedDescription)"
                        )
                    }
                }
            )

        case .userRecord,
             .suggestion,
             .searchResult:
            let attributes = eventsManager.prepareEventTemplate(for: "EventsManager.Events.feedback.rawValue")
            completion(attributes)
        }
    }
}

// MARK: Public

extension FeedbackManager {
    /// Send user feedback events.
    /// Does a result or suggestion have any problem with naming, location or something else? Please send feedback
    /// describing the issue!
    /// - Parameter event: Feedback event
    /// - Parameter autoFlush: sends feedback right after submitting, true by default
    /// - Throws: CoreSearchEngines errors and`SearchError.incorrectEventTemplate`
    public func sendEvent(_ event: FeedbackEvent, autoFlush: Bool = true) throws {
        guard let delegate else {
            assertionFailure("Delegate with Engine is required")
            _Logger.searchSDK.debug("Cant build FeedbackEvent, wouldn't send", category: .telemetry)
            return
        }
        do {
            event.viewPort = delegate.locationProviderWrapper?.getViewport()

            try buildTemplate(
                event: event,
                completion: { [weak self] template in
                    guard let self else { return }

                    do {
                        let attributes = try self.buildFeedbackAttributes(template, event: event)

                        self.sendFeedback(attributes: attributes, autoFlush: autoFlush)
                    } catch {
                        _Logger.searchSDK.debug("Unable to process FeedbackEvent", category: .telemetry)
                    }
                }
            )
        } catch {
            eventsManager.reportError(error)
            _Logger.searchSDK.debug("Unable to process FeedbackEvent", category: .telemetry)
            throw error
        }
    }
}
