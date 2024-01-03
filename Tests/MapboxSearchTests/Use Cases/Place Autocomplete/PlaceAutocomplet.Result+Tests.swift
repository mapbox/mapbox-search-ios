// Copyright © 2023 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class PlaceAutocompleteResultTests: XCTestCase {
    func testResultContainsISOCountryCodes() throws {
        let coreResult = CoreSearchResultStub(
            id: UUID().uuidString,
            type: .address
        )
        coreResult.metadata = .make(data: [
            "iso_3166_1": "US",
            "iso_3166_2": "US-NY"
        ])
        
        let searchResult = ServerSearchResult(
            coreResult: coreResult,
            response: CoreSearchResponseStub.successSample(results: [coreResult])
        )!
        
        let result = try PlaceAutocomplete.Suggestion.from(searchResult).result(for: searchResult)
        
        XCTAssertEqual(result.address?.countryISO1, "US")
        XCTAssertEqual(result.address?.countryISO2, "US-NY")
    }
}
