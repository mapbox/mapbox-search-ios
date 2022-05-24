import Foundation

protocol CoreSearchResponseProtocol {
    var requestID: UInt32 { get }
    var request: CoreRequestOptions { get }

    var result: Result<[CoreSearchResult], SearchError> { get }
    var responseUUID: String { get }
}

extension CoreSearchResponse: CoreSearchResponseProtocol {
    var result: Result<[CoreSearchResult], SearchError> {
        if let responseResults = results.value as? [CoreSearchResult] {
            return .success(responseResults)
        } else if let error = results.error?.getHttpError() {
            return .failure(
                .generic(
                    code: Int(error.httpCode),
                    domain: mapboxCoreSearchErrorDomain,
                    message: error.message)
            )
        } else {
            return .failure(.responseProcessingFailed)
        }
    }
}
