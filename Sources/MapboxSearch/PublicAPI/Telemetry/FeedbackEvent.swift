import CoreLocation
import Foundation

/// User Feedback event build based on SearchSuggestion or SearchResult.
/// Does a result or suggestion have any problem with naming, location or something else? Please send feedback
/// describing the issue!
/// Can be sent by calling `sendFeedback(event:)` method of any SearchEngine instance.
public class FeedbackEvent {
    /// Built-in set of reasons for feedback
    public enum Reason: String, CaseIterable {
        /// The name of attached suggestion/result is wrong.
        case name = "incorrect_name"

        /// The address of attached suggestion/result is wrong.
        case address = "incorrect_address"

        /// The coordinates of attached result is wrong.
        case location = "incorrect_location"

        /// Response doesn't include result that exists in real.
        case missingResult = "cannot_find"

        /// Any other feedback reason.
        case other = "other_result_issue"
    }

    enum EventType {
        case missingResult(response: CoreSearchResponseProtocol)
        case coreResult(response: CoreSearchResponseProtocol, result: CoreSearchResultProtocol)

        case userRecord(record: IndexableRecord)
        case suggestion(record: SearchSuggestion)
        case searchResult(record: SearchResult)
    }

    struct Attributes {
        var id: String
        var name: String
        var coordinate: CLLocationCoordinate2D?

        var query: String?
        var proximity: CLLocationCoordinate2D?

        init(record: IndexableRecord) {
            self.id = record.id
            self.name = record.address?.formattedAddress(style: .full) ?? "<No address>"
            self.coordinate = record.coordinate
        }

        init(record: SearchSuggestion) {
            self.id = record.id
            self.name = record.name
            self.query = record.searchRequest.query
            self.proximity = record.searchRequest.proximity
        }

        init(record: SearchResult) {
            self.id = record.id
            self.name = record.name
            self.coordinate = record.coordinate
        }
    }

    /// Feedback Reason e.g. incorrect name, translation, position...
    public var reason: String?

    /// Issue description.
    public var text: String?

    /// User keyboard locale.
    public var keyboardLocale: String?

    /// User device orientation.
    public var deviceOrientation: String?

    /// Screenshot attachment data.
    public var screenshotData: Data?

    /// Identifier for combining related Mapbox events.
    public var sessionId: String? {
        get { metadata.sessionId }
        set { metadata.sessionId = newValue }
    }

    var viewPort: CoreBoundingBox?

    var metadata = EventAppMetadata()

    var type: EventType

    /// Whatever search request can be reproduced later to get the same results as user get.
    /// Currently results from category suggestion and feedback without `CoreSearchResponse` are not `isReproducible`.
    var isReproducible: Bool

    init(type: EventType, reason: String?, text: String?, isReproducible: Bool = false) {
        self.type = type
        self.reason = reason
        self.text = text

        self.isReproducible = isReproducible
    }
}

// MARK: Public

extension FeedbackEvent {
    /// Build feedback event based on `IndexableRecord`.
    /// Such feedback provides minimum useful information and not so valuable.
    /// Consider using `init(record: SearchResult, reason: String?, text: String?)` for submitting feedbacks please.
    /// - Parameters:
    ///   - userRecord: userRecord to send feedback about
    ///   - reason: feedback reason string, FeedbackEvent.Reason enum has few default values( e.g. incorrect name,
    /// position, address ...)
    ///   - text: an issue description
    public convenience init(userRecord: IndexableRecord, reason: String?, text: String?) {
        self.init(type: .userRecord(record: userRecord), reason: reason, text: text)
    }

    /// Build feedback event based on SearchResult.
    /// - Parameters:
    ///   - result: `SearchResult` to send feedback about.
    ///   - reason: feedback reason string, `FeedbackEvent.Reason` enum has few default values( e.g. incorrect name,
    /// position, address ...)
    ///   - text: an issue description
    public convenience init(record: SearchResult, reason: String?, text: String?) {
        switch record {
        case let provider as CoreResponseProvider:
            let type = EventType.coreResult(
                response: provider.originalResponse.coreResponse,
                result: provider.originalResponse.coreResult
            )
            self.init(type: type, reason: reason, text: text, isReproducible: true)

        case let record as HistoryRecord:
            // Threat history record as SearchResult
            self.init(type: .searchResult(record: record), reason: reason, text: text)

        case let record as FavoriteRecord:
            // Threat favorite record as user record as it can contain PII data
            // userRecord feedback puts address instead of name
            self.init(type: .userRecord(record: record), reason: reason, text: text)

        default:
            self.init(type: .searchResult(record: record), reason: reason, text: text)
        }
    }

    /// Build feedback event based on SearchResult.
    /// - Parameters:
    ///   - result: `SearchResult` to send feedback about.
    ///   - reason: feedback reason as `FeedbackEvent.Reason`
    ///   - text: an issue description
    public convenience init(record: SearchResult, reason: Reason, text: String?) {
        self.init(record: record, reason: reason.rawValue, text: text)
    }

    /// Build feedback event based on SearchSuggestion.
    /// - Parameters:
    ///   - suggestion: SearchSuggestion to send feedback about.
    ///   - reason: Feedback Reason - e.g. incorrect name, translation, position...
    ///   - text: Issue additional description
    public convenience init(suggestion: SearchSuggestion, reason: String?, text: String?) {
        if let provider = suggestion as? CoreResponseProvider {
            self.init(
                type: .coreResult(
                    response: provider.originalResponse.coreResponse,
                    result: provider.originalResponse.coreResult
                ),
                reason: reason,
                text: text,
                isReproducible: true
            )
        } else {
            self.init(type: .suggestion(record: suggestion), reason: reason, text: text)
        }
    }

    /// Build feedback event of `Missing Search Result` type. This kind of event is used for reporting search issues
    /// where a user can’t find what he's looking for.
    /// - Parameters:
    ///   - response: `SearchResponseInfo` can be found in SearchEngine.responseInfo. Response info related to last
    /// search response.
    ///   - text: Issue additional description
    public convenience init(response: SearchResponseInfo, text: String?) {
        let isReproducible = response.suggestion?.suggestionType != .category
        self.init(
            type: .missingResult(response: response.coreResponse),
            reason: Reason.missingResult.rawValue,
            text: text,
            isReproducible: isReproducible
        )
    }
}
