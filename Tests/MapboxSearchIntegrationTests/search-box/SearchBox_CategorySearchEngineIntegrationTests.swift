import CoreLocation
@testable import MapboxSearch
import XCTest

final class SearchBox_CategorySearchEngineIntegrationTests: MockServerIntegrationTestCase<SearchBoxMockResponse> {
    private var searchEngine: CategorySearchEngine!
    private var searchOptions: SearchOptions!
    private var categorySearchOptions: CategorySearchOptions!

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
        categorySearchOptions = CategorySearchOptions(attributeSets: [.basic, .photos, .venue, .visit])
    }

    @available(*, deprecated, message: "")
    func testCategorySearchWithSearchOption() throws {
        try server.setResponse(.categoryCafe)

        let expectation = XCTestExpectation(description: "Expecting results")
        searchEngine.search(categoryName: "cafe", options: searchOptions) { [weak self] result in
            self?.checkCategorySearchResults(result, expectation: expectation)
        }
        wait(for: [expectation], timeout: 10)
    }

    func testCategorySearchWithCategorySearchOption() throws {
        try server.setResponse(.categoryCafe)

        let expectation = XCTestExpectation(description: "Expecting results")
        searchEngine.search(categoryName: "cafe", options: categorySearchOptions) { [weak self] result in
            self?.checkCategorySearchResults(result, expectation: expectation)
        }
        wait(for: [expectation], timeout: 10)
    }

    private func checkCategorySearchResults(
        _ result: Result<[SearchResult], SearchError>,
        expectation: XCTestExpectation
    ) {
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

    @available(*, deprecated, message: "")
    func testCategorySearchFailedWithSearchOptions() throws {
        try server.setResponse(.categoryCafe, statusCode: 500)

        let expectation = XCTestExpectation(description: "Expecting failure")
        searchEngine.search(categoryName: "cafe", options: searchOptions) { [weak self] result in
            self?.checkErrorCategorySearchResults(result, expectation: expectation)
        }
        wait(for: [expectation], timeout: 10)
    }

    func testCategorySearchFailedWithCategorySearchOptions() throws {
        try server.setResponse(.categoryCafe, statusCode: 500)

        let expectation = XCTestExpectation(description: "Expecting failure")
        searchEngine.search(categoryName: "cafe", options: categorySearchOptions) { [weak self] result in
            self?.checkErrorCategorySearchResults(result, expectation: expectation)
        }
        wait(for: [expectation], timeout: 10)
    }

    private func checkErrorCategorySearchResults(
        _ result: Result<[SearchResult], SearchError>,
        expectation: XCTestExpectation
    ) {
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
}
