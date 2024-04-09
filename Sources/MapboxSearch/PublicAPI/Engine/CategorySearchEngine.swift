import CoreLocation

/// Category Search Engine used specifically for category search
/// Checkout `SearchEngine` for more details
public class CategorySearchEngine: AbstractSearchEngine {
    /// Start searching for query with provided options
    /// - Parameters:
    ///   - categoryName: Search category name
    ///   - options: search request options
    ///   - completionQueue: DispatchQueue.main is default
    ///   - completion: completion closure
    public func search(
        categoryName: String,
        options: SearchOptions? = nil,
        completionQueue: DispatchQueue = .main,
        completion: @escaping (Result<[SearchResult], SearchError>) -> Void
    ) {
        userActivityReporter.reportActivity(forComponent: "search-engine-category-search")

        let options = options?.merged(defaultSearchOptions) ?? defaultSearchOptions
        let coreOptions = options.toCore(apiType: engineApi)
        engine.search(
            forQuery: "",
            categories: [categoryName],
            options: coreOptions
        ) { [weak self, weak eventsManager] coreResponse in
            guard let self else {
                completion(.failure(SearchError.owningObjectDeallocated))
                return
            }

            guard let coreResponse else {
                let error = SearchError.categorySearchRequestFailed(reason: SearchError.responseProcessingFailed)
                eventsManager?.reportError(error)

                completionQueue.async {
                    completion(.failure(error))
                }

                assertionFailure("Response should never be nil")
                return
            }

            let response = SearchResponse(coreResponse: coreResponse)
            switch response.process() {
            case .success(let result):
                let resultSuggestions = result.suggestions.compactMap { $0 as? SearchResultSuggestion }
                assert(
                    result.suggestions.count == resultSuggestions.count,
                    "Every search result in Category search must conform SearchResultSuggestion requirements"
                )

                self.resolve(suggestions: resultSuggestions, completionQueue: completionQueue) { resolvedResults in
                    completion(.success(resolvedResults))
                }

            case .failure(let searchError):
                self.eventsManager.reportError(searchError)
                completionQueue.async {
                    completion(.failure(searchError))
                }
            }
        }
    }
}
