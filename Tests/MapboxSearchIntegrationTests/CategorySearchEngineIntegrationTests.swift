import CoreLocation
@testable import MapboxSearch
import XCTest

class CategorySearchEngineIntegrationTests: MockServerTestCase {
    lazy var searchEngine = CategorySearchEngine(
        accessToken: "access-token",
        locationProvider: DefaultLocationProvider(),
        apiType: .SBS
    )

    func testCategorySearch() throws {
        try server.setResponse(.categoryCafe)

        let expectation = XCTestExpectation(description: "Expecting results")
        searchEngine.search(categoryName: "cafe") { result in
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
        searchEngine.search(categoryName: "cafe") { result in
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
