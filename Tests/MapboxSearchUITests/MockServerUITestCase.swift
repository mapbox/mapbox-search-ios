import Foundation

/// Base UI test case that uses mocked network responses extended on default testable app behavior.
/// Provide a type conforming to MockResponse and then make use of it when using `server` functions and properties.
class MockServerUITestCase<Mock: MockResponse>: BaseTestCase {
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

/// Specialized default test case that uses SBSMockResponse.
/// SBS is the recommended API engine type and default for the Demo app and UI test cases in the 2.0.0 release series.
typealias MockSBSServerUITestCase = MockServerUITestCase<SBSMockResponse>
