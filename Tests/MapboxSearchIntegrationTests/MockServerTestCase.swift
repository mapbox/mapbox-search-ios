import XCTest
import CoreLocation
@testable import MapboxSearch

class MockServerTestCase: XCTestCase {
    let server = MockWebServer()

    func setServerResponse(_ response: MockResponse, query: String? = nil) throws {
        try server.setResponse(response, query: query)
    }

    override func setUpWithError() throws {
        try super.setUpWithError()

        UserDefaults.standard.setValue(server.endpoint, forKey: "MapboxAPIBaseURL")

        try server.start()
    }

    override func tearDown() {
        super.tearDown()

        server.stop()
    }
}
