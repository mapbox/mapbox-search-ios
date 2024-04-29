@testable import MapboxSearch
import XCTest

extension SearchQuerySuggestionImpl {
    static let sample1 = SearchQuerySuggestionImpl(
        coreResult: CoreSearchResultStub(
            id: "sample-43",
            mapboxId: nil,
            type: .query,
            center: nil
        ),
        response: CoreSearchResponseStub(
            id: 42,
            options: .sample1,
            result: .success([])
        )
    )
}
