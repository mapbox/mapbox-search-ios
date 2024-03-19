import Foundation

#if DEBUG
/// Mapbox Search SDK error domain – Debug version
public let mapboxSearchErrorDomain = "MapboxSearchErrorDomain_debug"
#else
/// Mapbox Search SDK error domain
public let mapboxSearchErrorDomain = "MapboxSearchErrorDomain"
#endif

/// Common SearchSDK errors
public enum SearchError: Error {
    /// Generic type of error. Mostly kind of bridge from NSError.
    case generic(code: Int, domain: String, message: String)

    /// Feedback event template has a mistake.
    case incorrectEventTemplate

    /// Feedback event contains incorrect search result object.
    case incorrectSearchResultForFeedback

    /// Search request is broken. Checkout `reason` value for details.
    case searchRequestFailed(reason: Error)

    /// Category search request is broken. Checkout `reason` value for details.
    case categorySearchRequestFailed(reason: Error)

    /// Cannot register custom data provider. Checkout `reason` value for details.
    case failedToRegisterDataProvider(reason: Error, dataProvider: IndexableDataProvider)

    /// Cannot process search response.
    case responseProcessingFailed

    /// Request was cancelled.
    case searchRequestCancelled

    /// Request was failed due to internal error.
    case internalSearchRequestError(message: String)

    /// Cannot fetch suggestion details.
    case resultResolutionFailed(SearchResultSuggestion)

    /// Cannot find data resolver for suggestion to fetch details.
    case dataResolverNotFound(SearchResultSuggestion)

    /// Reverse geocoding request was failed. Checkout `reason` value for details.
    case reverseGeocodingFailed(reason: Error, options: ReverseGeocodingOptions)

    /// Weak-self could not be unwrapped because the owning reference was weak. Please replace with a strong-ownership
    /// reference.
    case owningObjectDeallocated

    init(_ error: NSError) {
        self = .generic(code: error.code, domain: error.domain, message: error.description)
    }
}

extension SearchError: Equatable {
    /// Compare errors as `NSError` types
    public static func == (lhs: SearchError, rhs: SearchError) -> Bool {
        return (lhs as NSError) == (rhs as NSError)
    }
}
