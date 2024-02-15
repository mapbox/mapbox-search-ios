import CoreLocation
@testable import MapboxSearch
import XCTest

class MockServerIntegrationTestCase: XCTestCase {
    let server = MockWebServer()

    func setServerResponse(_ response: MockResponse, query: String? = nil) throws {
        try server.setResponse(response, query: query)
    }

    override func setUpWithError() throws {
        try super.setUpWithError()

        LocalhostMockServiceProvider.customBaseURL = server.endpoint

        try server.start()
    }

    override func tearDown() {
        super.tearDown()

        server.stop()
    }
}
