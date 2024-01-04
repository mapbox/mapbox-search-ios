import Foundation

protocol CoreSearchResponseProtocol {
    var request: CoreRequestOptions { get }

    var result: Result<[CoreSearchResult], SearchError> { get }
    var responseUUID: String { get }
}

extension CoreSearchResponse: CoreSearchResponseProtocol {
    var result: Result<[CoreSearchResult], SearchError> {
        if let responseResults = results.value as? [CoreSearchResult] {
            return .success(responseResults)
        } else if let error = results.error {
            if error.isHttpError() {
                let httpError = error.getHttpError()

                return .failure(
                    .generic(
                        code: Int(httpError.httpCode),
                        domain: mapboxCoreSearchErrorDomain,
                        message: httpError.message
                    )
                )
            } else if error.isInternalError() {
                let internalError = error.getInternalError()

                _Logger.searchSDK.error("Search request failed: \(internalError.message)")

                return .failure(
                    .internalSearchRequestError(
                        message: internalError.message
                    )
                )
            } else if error.isRequestCancelled() {
                _Logger.searchSDK.error("Search request cancelled")

                return .failure(.searchRequestCancelled)
            } else {
                return .failure(.responseProcessingFailed)
            }
        } else {
            return .failure(.responseProcessingFailed)
        }
    }
}
