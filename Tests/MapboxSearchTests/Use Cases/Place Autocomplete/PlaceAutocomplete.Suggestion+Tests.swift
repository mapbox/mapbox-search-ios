@testable import MapboxSearch
import XCTest

final class PlaceAutocompleteSuggestionTests: XCTestCase {
    private let options = CoreRequestOptions.sample1

    func testCreationFromCoreResult() {
        let results = CoreSearchResultStub.makeMixedResultsSet().map(\.asCoreSearchResult)
        let result = ServerSearchResult(
            coreResult: CoreSearchResultStub.sample1,
            response: CoreSearchResponseStub.successSample(results: results)
        )!

        let suggestion = try? PlaceAutocomplete.Suggestion.from(result)
        XCTAssertNotNil(suggestion)
        guard case .result = suggestion!.underlying else {
            XCTFail("Should have underlying result")
            return
        }

        XCTAssertEqual(suggestion?.estimatedTime, CoreSearchResultStub.sample1.estimatedTime)
        XCTAssertEqual(suggestion?.distance, CoreSearchResultStub.sample1.distanceToProximity)
    }

    func testCreationFromCoreSuggestion() {
        let coreSuggestion = CoreSearchResultStub.makeSuggestion()
        coreSuggestion.resultTypes = [.poi]
        coreSuggestion.center = CLLocation(latitude: 10.0, longitude: 20.0)

        let suggestion = try? PlaceAutocomplete.Suggestion.from(
            searchSuggestion: coreSuggestion,
            options: options
        )
        XCTAssertNotNil(suggestion)
        guard case .suggestion = suggestion!.underlying else {
            XCTFail("Should have underlying suggestion")
            return
        }
    }

    func testCreationFromCoreSuggestionIfIncorrectCoordinate() {
        let coreSuggestion = CoreSearchResultStub.makeSuggestion()

        XCTAssertThrowsError(
            try PlaceAutocomplete.Suggestion.from(
                searchSuggestion: coreSuggestion,
                options: options
            ),
            "PlaceAutocomplete.Suggestion objects can't be created with nil coordinate"
        ) { errorThrown in
            XCTAssertEqual(errorThrown as? PlaceAutocomplete.Suggestion.Error, .invalidCoordinates)
        }
    }

    func testCreationFromCoreSuggestionIfCategoryType() {
        let coreSuggestion = CoreSearchResultStub.makeSuggestion()
        coreSuggestion.resultTypes = [.category]

        XCTAssertThrowsError(
            try PlaceAutocomplete.Suggestion.from(
                searchSuggestion: coreSuggestion,
                options: options
            ),
            "PlaceAutocomplete.Suggestion objects can't be created with category type"
        ) { errorThrown in
            XCTAssertEqual(errorThrown as? PlaceAutocomplete.Suggestion.Error, .invalidResultType)
        }
    }

    func testCreationFromCoreSuggestionIfQueryType() {
        let coreSuggestion = CoreSearchResultStub.makeSuggestion()
        coreSuggestion.resultTypes = [.query]

        XCTAssertThrowsError(
            try PlaceAutocomplete.Suggestion.from(
                searchSuggestion: coreSuggestion,
                options: options
            ),
            "PlaceAutocomplete.Suggestion objects can't be created with query type"
        ) { errorThrown in
            XCTAssertEqual(errorThrown as? PlaceAutocomplete.Suggestion.Error, .invalidResultType)
        }
    }
}
