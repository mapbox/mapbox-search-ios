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

/// Compatible with completion-block-based Forward-endpoint. Does not support delegation based searches.
class ForwardExampleSearchEngine: ObservableObject {
    let searchEngine = SearchEngine(apiType: .searchBox)

    @Published
    var queryResult: ForwardQueryResult = .init(result: .success([]))

    @Published
    var query: String = ""

    // MARK: - Forward Wrapper

    func forwardSearch() {
        searchEngine.forward(query: query) { [weak self] result in
            self?.queryResult = ForwardQueryResult(result: result)
        }
    }
}
