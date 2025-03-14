import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchEngineGeocodingIntegrationTests: MockServerIntegrationTestCase<GeocodingMockResponse> {
    var delegate: SearchEngineDelegateStub!
    var searchEngine: SearchEngine!

    override func setUpWithError() throws {
        try super.setUpWithError()

        delegate = SearchEngineDelegateStub()
        let apiType = try XCTUnwrap(Mock.coreApiType.toSDKType())
        searchEngine = try SearchEngine(
            accessToken: "access-token",
            serviceProvider: ServiceProvider.shared,
            locationProvider: DefaultLocationProvider(),
            apiType: apiType,
            baseURL: mockServerURL()
        )

        searchEngine.delegate = delegate
    }

    func testReverseGeocodingSearch() throws {
        try server.setResponse(.reverseGeocoding)

        let expectation = XCTestExpectation()
        let options = ReverseGeocodingOptions(point: CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0))

        // Search engine is a SBS type!
        searchEngine.reverse(options: options) { result in
            if case .success(let reverseGeocodingResults) = result {
                XCTAssertFalse(reverseGeocodingResults.isEmpty)
            } else {
                XCTFail("No resolved result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    func testReverseGeocodingSearchFailed() throws {
        try server.setResponse(.reverseGeocoding, statusCode: 500)

        let expectation = XCTestExpectation()
        let options = ReverseGeocodingOptions(point: CLLocationCoordinate2D(latitude: 12.0, longitude: 12.0))
        searchEngine.reverse(options: options) { result in
            if case .failure(.reverseGeocodingFailed(let reasonError as NSError, _)) = result {
                XCTAssert(reasonError.code == 500)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10)
    }
}
