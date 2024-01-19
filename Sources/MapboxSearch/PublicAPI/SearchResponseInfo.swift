import Foundation

/// Search Response information. Contains search options.
/// This response can be used for sending Missing Result feedback. One should build `FeedbackEvent` using
/// `SearchResponseInfo`
/// `SearchEngine.sendFeedback(event: FeedbackEvent, autoFlush: Bool = true) throws`
public class SearchResponseInfo {
    let coreResponse: CoreSearchResponseProtocol

    /// Associated search suggestion if available.
    public let suggestion: SearchSuggestion?

    /// Search request options.
    public let options: SearchOptions

    // Note: consider make public version of `CoreSearchResponseProtocol`.
    init(response: CoreSearchResponseProtocol, suggestion: SearchSuggestion?) {
        self.coreResponse = response
        self.suggestion = suggestion
        self.options = SearchOptions(coreSearchOptions: response.request.options)
    }
}
