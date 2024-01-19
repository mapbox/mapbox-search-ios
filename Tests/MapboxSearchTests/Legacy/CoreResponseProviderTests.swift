import CoreLocation
@testable import MapboxSearch
import XCTest

class CoreResponseProviderStub: CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse

    init(originalResponse: CoreSearchResultResponse) {
        self.originalResponse = originalResponse
    }
}

class CoreResponseProviderTests: XCTestCase {
    func testSearchRequestComputedVariable() throws {
        let coreResponse = CoreSearchResultResponse(
            coreResult: CoreSearchResultStub.sample1,
            response: CoreSearchResponseStub
                .successSample(results: [CoreSearchResultStub.sample1])
        )

        let responseProvider = CoreResponseProviderStub(originalResponse: coreResponse)

        XCTAssertEqual(responseProvider.searchRequest.proximity, .sample1)
        XCTAssertEqual(responseProvider.searchRequest.query, "sample-1")
    }
}
