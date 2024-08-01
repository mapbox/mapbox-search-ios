// Copyright © 2024 Mapbox. All rights reserved.

@testable import MapboxSearch
import XCTest

final class SearchBox_RetrieveDetailsIntegrationTests: XCTestCase {
    private var searchEngine: SearchEngine!
    private var delegate = SearchEngineDelegateStub()

    private let museumMapboxId = "dXJuOm1ieHBvaTplYWEwZGQyYS0xZGE3LTQwOWEtOGYyZC0wYmU2MDhlYzQxZTc"

    override func setUpWithError() throws {
        try super.setUpWithError()

        searchEngine = SearchEngine(apiType: .searchBox)
        searchEngine.delegate = delegate
    }

    func testRetrieveDetailsInvalidInput() throws {
        let options = DetailsOptions(
            attributeSets: [.visit],
            language: "en",
            worldview: nil,
            baseUrl: nil
        )

        let completionExpectation = XCTestExpectation()

        searchEngine.retrieveDetails(for: "invalidInput", options: options) { response in
            switch response {
            case .success(let success):
                XCTFail("\(#function) should test an invalid input")
            case .failure(let failure):
                XCTAssertEqual(failure.errorCode, 400)
                XCTAssertTrue(failure.localizedDescription.localizedStandardContains("The Mapbox ID is invalid"))
            }

            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation])
    }

    func testRetrieveDetailsMuseumVisit() throws {
        let options = DetailsOptions(
            attributeSets: [.visit],
            language: "en",
            worldview: nil,
            baseUrl: nil
        )

        let completionExpectation = XCTestExpectation()

        searchEngine.retrieveDetails(for: museumMapboxId, options: options) { response in
            switch response {
            case .success(let success):
                XCTFail("\(#function) should test an invalid input")
            case .failure(let failure):
                XCTAssertEqual(failure.errorCode, 400)
                XCTAssertTrue(failure.localizedDescription.localizedStandardContains("The Mapbox ID is invalid"))
            }

            completionExpectation.fulfill()
        }

        wait(for: [completionExpectation])
    }
}
