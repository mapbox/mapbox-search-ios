import Foundation

class MockServerTestCase: BaseTestCase {
    let server = MockWebServer()

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
