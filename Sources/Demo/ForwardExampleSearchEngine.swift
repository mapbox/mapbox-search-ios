// Copyright © 2024 Mapbox. All rights reserved.

import MapboxSearch
import SwiftUI

class ForwardQueryResult {
    var results: [SearchResult]?
    var error: SearchError?

    init(result: Result<[SearchResult], SearchError>) {
        switch result {
        case .success(let success):
            self.results = success
            self.error = nil
        case .failure(let failure):
            self.results = nil
            self.error = failure
        }
    }
}

class SelectForwardResult {
    var result: SearchResult?
    var error: SearchError?

    init(result: Result<SearchResult, SearchError>) {
        switch result {
        case .success(let success):
            self.result = success
            self.error = nil
        case .failure(let failure):
            self.result = nil
            self.error = failure
        }
    }
}

/// Compatible with completion-block-based Forward-endpoint. Does not support delegation based searches.
class ForwardExampleSearchEngine: ObservableObject {
    let searchEngine = SearchEngine(apiType: .searchBox)

    @Published
    /// Store results of a forward/ query
    var queryResult: ForwardQueryResult = .init(result: .success([]))

    @Published
    /// Store result of running retrieve/ on the result from an earlier forward/ query
    var selectResult: SelectForwardResult?

    @Published
    var query: String = ""

    // MARK: - Forward Wrapper

    func forwardSearch() {
        searchEngine.forward(query: query) { [weak self] result in
            self?.selectResult = nil
            self?.queryResult = ForwardQueryResult(result: result)
        }
    }

    // MARK: - Retrieve Wrapper (for details)

    func retrieveSearch(_ searchResult: SearchResult) {
        searchEngine.select(forwardResult: searchResult) { [weak self] result in
            self?.selectResult = SelectForwardResult(result: result)
        }
    }
}
