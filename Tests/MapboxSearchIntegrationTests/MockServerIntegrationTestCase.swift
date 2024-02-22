import CoreLocation
@testable import MapboxSearch
import XCTest

class MockServerIntegrationTestCase<Mock: MockResponse>: XCTestCase {
    typealias Mock = Mock
    let server = MockWebServer<Mock>()

    func setServerResponse(_ response: Mock, query: String? = nil) throws {
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
