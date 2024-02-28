import CoreLocation
@testable import MapboxSearch
import XCTest

class CategoryIntegrationTests: MockServerIntegrationTestCase<SBSMockResponse> {
    lazy var searchEngine = Category(locationProvider: DefaultLocationProvider())

    func testCategorySearchAlongRouteWithCountryProximityOrigin() throws {
        try server.setResponse(.categoryHotelSearchAlongRoute_JP)
        let expectation = XCTestExpectation(description: "Expecting results")

        let coordinate1 = CLLocationCoordinate2D(latitude: 35.655614, longitude: 139.7081684)
        let coordinate2 = CLLocationCoordinate2D(latitude: 35.6881616, longitude: 139.6994339)
        let coordinates = [coordinate1, coordinate2]

        let mapboxSearchRoute = MapboxSearch.Route(coordinates: coordinates)
        let rOptions: MapboxSearch.RouteOptions = RouteOptions(route: mapboxSearchRoute, time: 1000)

        let options = Category.Options(
            limit: 10,
            language: nil,
            country: Country(countryCode: "jp"),
            proximity: CLLocationCoordinate2D(
                latitude: 35.6634363,
                longitude: 139.7394536
            ),
            origin: CLLocationCoordinate2D(latitude: 35.66580, longitude: 139.74609)
        )

        searchEngine.search(
            for: Category.Item.hotel,
            route: rOptions,
            options: options
        ) { result in
            switch result {
            case .success(let searchResults):
                XCTAssertFalse(searchResults.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail("Error not expected")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
