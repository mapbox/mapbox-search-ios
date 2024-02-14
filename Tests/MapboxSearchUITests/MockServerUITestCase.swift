import Foundation

class MockServerUITestCase: BaseTestCase {
    let server = MockWebServer<LegacyResponse>()

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
