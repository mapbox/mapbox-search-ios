@testable import MapboxSearch
import XCTest

extension SearchCategorySuggestionImpl {
    static let sample1 = SearchCategorySuggestionImpl(
        coreResult: CoreSearchResultStub(
            id: "sample-2",
            type: .category,
            center: nil
        ),
        response: CoreSearchResponseStub(
            id: 42,
            options: .sample1,
            result: .success([])
        )
    )
}
