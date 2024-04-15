// Copyright © 2024 Mapbox. All rights reserved.

@testable import MapboxSearch
import XCTest

/// Tests for SearchEngine objects that fail `guard-let-self` unwrapping during network response completion blocks.
/// These exemplify incorrect behavior such as: `Category().search(for: ...` —— you must keep an owning
/// reference to a search engine that you instantiate and use for network requests.
final class OwningObjectDeallocatedErrorTests: MockServerIntegrationTestCase<SBSMockResponse> {
    /// Do not use Category() this way because you will hit the same error.
    /// Instead you should own your category instance, such as: `let category = Category()`
    func test_category_object() throws {
        try server.setResponse(.categoryHotelSearchAlongRoute_JP)
        let expectation = XCTestExpectation(description: "Expecting results")
        let coordinate1 = CLLocationCoordinate2D(latitude: 35.655614, longitude: 139.7081684)

        Discover(locationProvider: DefaultLocationProvider())
            .search(for: .Category.coffeeShopCafe, proximity: coordinate1) { response in
                if case .failure(let failure) = response,
                   let searchFailure = failure as? SearchError
                {
                    XCTAssertEqual(
                        searchFailure,
                        SearchError.owningObjectDeallocated
                    )
                    expectation.fulfill()
                } else {
                    XCTFail(
                        "Expected transient Category() instance to be deallocated before network response completed resulting in an error."
                    )
                }
            }
        wait(for: [expectation], timeout: 10)
    }
}
