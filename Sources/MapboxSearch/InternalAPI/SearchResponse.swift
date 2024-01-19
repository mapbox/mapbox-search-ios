import Foundation

typealias ProcessedSearchResponse = Result<(suggestions: [SearchSuggestion], results: [SearchResult]), SearchError>

final class SearchResponse {
    let coreResponse: CoreSearchResponseProtocol

    init(coreResponse: CoreSearchResponseProtocol) {
        self.coreResponse = coreResponse
    }

    func process() -> ProcessedSearchResponse {
        switch coreResponse.result {
        case .success(let coreSearchResults):
            return .success(
                processResults(coreSearchResults)
            )

        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - Private

extension SearchResponse {
    private func processResults(_ responseResults: [CoreSearchResult]) -> (
        suggestions: [SearchSuggestion],
        results: [SearchResult]
    ) {
        var results = [SearchResult]()
        let suggestions = responseResults.compactMap { coreResult -> SearchSuggestion? in
            let suggestion: SearchSuggestion?
            switch coreResult.resultTypes {
            case [.query]:
                suggestion = SearchQuerySuggestionImpl(coreResult: coreResult, response: coreResponse)

            case [.category]:
                suggestion = SearchCategorySuggestionImpl(coreResult: coreResult, response: coreResponse)

            case [.userRecord]:
                suggestion = ExternalRecordPlaceholder(coreResult: coreResult, response: coreResponse)

            case _ where coreResult.resultTypes.contains(.unknown):
                suggestion = nil

            default:
                if coreResult.center != nil, let serverSearchResult = ServerSearchResult(
                    coreResult: coreResult,
                    response: coreResponse
                ) {
                    results.append(serverSearchResult)

                    // All results should go to suggestions as well. They are stored in SearchEngine.items field
                    // and can be resolved later. SearchResult isn't stored anywhere in SearchEngine.
                    suggestion = serverSearchResult
                } else {
                    suggestion = SearchResultSuggestionImpl(coreResult: coreResult, response: coreResponse)
                }
            }

            return suggestion
        }

        return (suggestions, results)
    }
}
