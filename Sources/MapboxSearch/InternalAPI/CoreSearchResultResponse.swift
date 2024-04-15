class CoreSearchResultResponse {
    init(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        self.coreResult = coreResult
        self.coreResponse = response
    }

    var requestOptions: CoreRequestOptions {
        coreResponse.request
    }

    var coreResponse: CoreSearchResponseProtocol
    var coreResult: CoreSearchResultProtocol
}
