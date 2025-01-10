import CoreLocation
@testable import MapboxSearch
import XCTest

final class SearchBox_CategorySearchEngineIntegrationTests: MockServerIntegrationTestCase<SearchBoxMockResponse> {
    private var searchEngine: CategorySearchEngine!
    private var searchOptions: SearchOptions!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let apiType = try XCTUnwrap(Mock.coreApiType.toSDKType())
        searchEngine = try CategorySearchEngine(
            accessToken: "access-token",
            serviceProvider: ServiceProvider.shared,
            apiType: apiType,
            baseURL: mockServerURL()
        )
        searchOptions = SearchOptions(attributeSets: [.basic, .photos, .venue, .visit])
    }

    func testCategorySearch() throws {
        try server.setResponse(.categoryCafe)

        let expectation = XCTestExpectation(description: "Expecting results")
        searchEngine.search(categoryName: "cafe", options: searchOptions) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let searchResults):
                XCTAssertFalse(searchResults.isEmpty)
                let matchingNames = searchResults.compactMap(\.matchingName)
                XCTAssertTrue(matchingNames.isEmpty)
                let queryParams = self.server.passedRequests.last!.queryParams
                let attributeSetsParam = queryParams.first {
                    $0.0 == "attribute_sets"
                }?.1
                XCTAssertEqual(attributeSetsParam, "basic,photos,venue,visit")
                expectation.fulfill()
            case .failure:
                XCTFail("Error not expected")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testCategorySearchFailed() throws {
        try server.setResponse(.categoryCafe, statusCode: 500)

        let expectation = XCTestExpectation(description: "Expecting failure")
        searchEngine.search(categoryName: "cafe", options: searchOptions) { result in
            switch result {
            case .success:
                XCTFail("Not expected")
            case .failure(let searchError):
                if case .generic(let code, _, _) = searchError {
                    XCTAssert(code == 500)
                } else {
                    XCTFail("Not expected")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
