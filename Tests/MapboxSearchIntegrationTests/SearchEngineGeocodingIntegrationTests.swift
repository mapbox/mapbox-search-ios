import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchEngineGeocodingIntegrationTests: MockServerIntegrationTestCase {
    let delegate = SearchEngineDelegateStub()
    var searchEngine: SearchEngine!

    override func setUp() {
        super.setUp()

        searchEngine = SearchEngine(
            accessToken: "access-token",
            serviceProvider: LocalhostMockServiceProvider.shared,
            locationProvider: DefaultLocationProvider(),
            apiType: .geocoding
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
