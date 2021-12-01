import Foundation

typealias ProcessedSearchResponse = Result<(suggestions: [SearchSuggestion], results: [SearchResult]), SearchError>

class SearchResponse {
    let coreResponse: CoreSearchResponseProtocol
    let associatedError: Error?
    
    init(coreResponse: CoreSearchResponseProtocol, associatedError: Error?) {
        self.coreResponse = coreResponse
        self.associatedError = associatedError
    }
    
    func process() -> ProcessedSearchResponse {
        guard coreResponse.isIsSuccessful else {
            if let error = associatedError as NSError? {
                return .failure(SearchError(error))
            } else {
                return .failure(.generic(code: Int(coreResponse.httpCode),
                                         domain: mapboxCoreSearchErrorDomain,
                                         message: coreResponse.message))
            }
        }
        
        var results = [SearchResult]()
        let suggestions = coreResponse.results.compactMap { coreResult -> SearchSuggestion? in
            let suggestion: SearchSuggestion?
            switch coreResult.resultTypes {
            case [.query]:
                suggestion = SearchQuerySuggestionImpl(coreResult: coreResult, response: coreResponse)
            case [.category]:
                suggestion = SearchCategorySuggestionImpl(coreResult: coreResult, response: coreResponse)
            case [.userRecord]:
                suggestion = ExternalRecordPlaceholder(coreResult: coreResult, response: coreResponse)
            case _ where coreResult.resultTypes.contains(.unknown):
                assertionFailure("Unsupported configuration")
                suggestion = nil
            default:
                if coreResult.center != nil, let serverSearchResult = ServerSearchResult(coreResult: coreResult, response: coreResponse) {
                    results.append(serverSearchResult)
                    // All results should go to suggestions as well. They are stored in SearchEngine.items field
                    // and can be resolved later. SearchResult isn't stored anywhere in SearchEngine.
                    suggestion = serverSearchResult
                } else {
                    suggestion = SearchResultSuggestionImpl(coreResult: coreResult, response: coreResponse)
                }
            }
            assert(suggestion != nil, "Nil searchResult means missing business logic. Please, review current implementation")
            return suggestion
        }
        
        return .success((suggestions, results))
    }
}
