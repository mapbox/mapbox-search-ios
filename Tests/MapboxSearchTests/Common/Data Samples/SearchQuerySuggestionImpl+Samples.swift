import XCTest
@testable import MapboxSearch

extension SearchQuerySuggestionImpl {
    static let sample1 = SearchQuerySuggestionImpl(coreResult: CoreSearchResultStub(id: "sample-43",
                                                                                    mapboxId: "sample-43",
                                                                                    type: .query,
                                                                                    centerLocation: nil),
                                                   response: CoreSearchResponseStub(id: 42,
                                                                                    options: .sample1,
                                                                                    result: .success([])))
}
