@testable import MapboxSearch
import XCTest

final class PlaceAutocompleteResultTests: XCTestCase {
    func testResultContainsISOCountryCodes() throws {
        let coreResult = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: "",
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

    func testCreateFromCoreSearchResult() throws {
        let coreResult = CoreSearchResultStub.makeSuggestion()
        let response = CoreSearchResponseStub.successSample(results: [coreResult])
        let searchResult = ServerSearchResult(coreResult: coreResult, response: response)!
        let result = try PlaceAutocomplete.Suggestion.from(searchResult)
            .result(for: searchResult)
        XCTAssertEqual(result.boundingBox, BoundingBox(.sample1, .sample2))
        XCTAssertEqual(result.categories, coreResult.categories)
        XCTAssertEqual(result.categoryIds, coreResult.categoryIDs)
    }
}
