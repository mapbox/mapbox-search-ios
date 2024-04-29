@testable import MapboxSearch
import XCTest

final class PlaceAutocompleteResultTests: XCTestCase {
    func testResultContainsISOCountryCodes() throws {
        let coreResult = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .address
        )
        coreResult.metadata = .make(data: [
            "iso_3166_1": "US",
            "iso_3166_2": "US-NY",
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
