import CoreLocation
@testable import MapboxSearch
import XCTest

class MockServerIntegrationTestCase<Mock: MockResponse>: XCTestCase {
    typealias Mock = Mock
    let server = MockWebServer<Mock>()

    /// Provide test case subclasses with a throwable unwrapped URL
    func mockServerURL() throws -> URL {
        try XCTUnwrap(URL(string: server.endpoint))
    }

    func setServerResponse(_ response: Mock, query: String? = nil) throws {
        try server.setResponse(response, query: query)
    }

    /// Each test invocation should retrieve `server.endpoint` for customizing SearchEngine baseURLs programmatically
    override func setUpWithError() throws {
        try super.setUpWithError()

        try server.start()
    }

    override func tearDown() {
        super.tearDown()

        server.stop()
    }
}
