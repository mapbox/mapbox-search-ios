protocol CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse { get }
}

extension CoreResponseProvider {
    var searchRequest: SearchRequestOptions {
        SearchRequestOptions(
            query: originalResponse.requestOptions.query,
            proximity: originalResponse.requestOptions.options.proximity?.coordinate
        )
    }
}
