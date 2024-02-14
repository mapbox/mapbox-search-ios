import Foundation

class MockServerUITestCase<Mock: MockResponse>: BaseTestCase {
    typealias Mock = Mock
    let server = MockWebServer<Mock>()

    override func setUpWithError() throws {
        try super.setUpWithError()

        try server.start()

        app.launchEnvironment["search_endpoint"] = server.endpoint
    }

    override func tearDown() {
        super.tearDown()

        server.stop()
    }
}
