import CoreLocation
@testable import MapboxSearch
import XCTest

final class CategorySearchEngineIntegrationTests: MockServerIntegrationTestCase {
    private var searchEngine: CategorySearchEngine!

    override func setUp() {
        super.setUp()

        let reporter = CoreUserActivityReporter.getOrCreate(
            for: CoreUserActivityReporterOptions(
                sdkInformation: SdkInformation.defaultInfo,
                eventsUrl: nil
            )
        )

        let supportSBS = true

        searchEngine = CategorySearchEngine(
            accessToken: "access-token",
            serviceProvider: LocalhostMockServiceProvider.shared,
            apiType: .SBS
        )
    }

    func testCategorySearch() throws {
        try server.setResponse(.categoryCafe)

        let expectation = XCTestExpectation(description: "Expecting results")
        searchEngine.search(categoryName: "ATM") { result in
            switch result {
            case .success(let searchResults):
                XCTAssertFalse(searchResults.isEmpty)
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
        searchEngine.search(categoryName: "ATM") { result in
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
