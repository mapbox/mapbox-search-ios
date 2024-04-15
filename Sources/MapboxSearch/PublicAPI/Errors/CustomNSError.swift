import Foundation

extension SearchError: CustomNSError {
    /// Mapbox Search SDK error domain
    public static var errorDomain: String = mapboxSearchErrorDomain

    /// Search Error unique code (across enum)
    public var errorCode: Int {
        switch self {
        case .generic(let code, _, _): return code
        case .incorrectEventTemplate: return -1
        case .incorrectSearchResultForFeedback: return -2
        case .searchRequestFailed: return -3
        case .categorySearchRequestFailed: return -4
        case .failedToRegisterDataProvider: return -5
        case .responseProcessingFailed: return -6
        case .resultResolutionFailed: return -7
        case .dataResolverNotFound: return -8
        case .reverseGeocodingFailed: return -9
        case .searchRequestCancelled: return -10
        case .internalSearchRequestError: return -11
        case .owningObjectDeallocated: return -12
        }
    }

    /// Associated userInfo
    public var errorUserInfo: [String: Any] {
        switch self {
        case .generic(_, _, message: let message):
            return [NSLocalizedDescriptionKey: message, NSLocalizedFailureReasonErrorKey: ""]

        case .incorrectEventTemplate:
            return [
                NSLocalizedDescriptionKey: "SearchEngine unable create event template",
                NSLocalizedFailureReasonErrorKey: "",
            ]

        case .incorrectSearchResultForFeedback:
            return [
                NSLocalizedDescriptionKey: "Passed SearchResult invalid for feedback",
                NSLocalizedFailureReasonErrorKey: "",
            ]

        case .searchRequestFailed(let error as NSError):
            return [
                NSLocalizedDescriptionKey: "Search Request Failed,",
                NSLocalizedFailureReasonErrorKey: "Error:[\(error.description)]",
            ]

        case .searchRequestCancelled:
            return [NSLocalizedDescriptionKey: "Search Request Cancelled,", NSLocalizedFailureReasonErrorKey: ""]

        case .internalSearchRequestError(let message):
            return [
                NSLocalizedDescriptionKey: "Internal Search Request Error,",
                NSLocalizedFailureReasonErrorKey: "Error:[\(message)]",
            ]

        case .categorySearchRequestFailed(let error as NSError):
            return [
                NSLocalizedDescriptionKey: "Category Search Request Failed,",
                NSLocalizedFailureReasonErrorKey: "Error:[\(error.description)]",
            ]

        case .failedToRegisterDataProvider(let error as NSError, let dataProvider):
            let description = "Failed To Register DataProvider:[\(type(of: dataProvider).providerIdentifier)],"
            return [
                NSLocalizedDescriptionKey: description,
                NSLocalizedFailureReasonErrorKey: "Error:[\(error.description)]",
            ]

        case .responseProcessingFailed:
            return [
                NSLocalizedDescriptionKey: "Search Response Processing Failed,",
                NSLocalizedFailureReasonErrorKey: "Probably got Nil CoreResponse",
            ]

        case .resultResolutionFailed(let suggestion):
            let description =
                "Search Result resolution failed, Layer:[\(suggestion.dataLayerIdentifier)], Name:[\(suggestion.name)]"
            return [NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: ""]

        case .dataResolverNotFound(let suggestion):
            let description =
                "Data Resolver not Found, Layer:[\(suggestion.dataLayerIdentifier)], Name:[\(suggestion.name)]"
            return [NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: ""]

        case .reverseGeocodingFailed(let error as NSError, let options):
            let description = "Reverse geocoding failed, Point:[\(options.point)],"
            return [
                NSLocalizedDescriptionKey: description,
                NSLocalizedFailureReasonErrorKey: "Error:[\(error.description)]",
            ]
        case .owningObjectDeallocated:
            let description = "Owning object deallocated"
            let reason =
                "Weak-self could not be unwrapped because the owning reference was weak. Please replace with a strong-ownership reference."
            return [
                NSLocalizedDescriptionKey: description,
                NSLocalizedFailureReasonErrorKey: reason,
            ]
        }
    }
}
