// Copyright © 2024 Mapbox. All rights reserved.

import CoreLocation
@testable import MapboxSearch
import XCTest

class SearchEngineForwardIntegrationTests: XCTestCase {
    var delegate: SearchEngineDelegateStub!
    var searchEngine: SearchEngine!

    override func setUpWithError() throws {
        try super.setUpWithError()

        delegate = SearchEngineDelegateStub()
        searchEngine = SearchEngine(
            serviceProvider: ServiceProvider.shared,
            locationProvider: DefaultLocationProvider(),
            apiType: .searchBox
        )

        searchEngine.delegate = delegate
    }

    // Note that Forward is only compatible with ApiType.searchBox
    func testForwardSearch() throws {
        let completionExpectation = XCTestExpectation()
        searchEngine.forward(query: "coffee shop") { response in
            switch response {
            case .success(let success):
                XCTAssertTrue(!success.isEmpty)

            case .failure(let failure):
                XCTFail(failure.localizedDescription)
            }
            completionExpectation.fulfill()
        }
        wait(for: [completionExpectation], timeout: 10)
    }
}
