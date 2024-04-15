@testable import MapboxSearch
import XCTest

final class PlaceAutocompleteTests: XCTestCase {
    private var searchEngine: CoreSearchEngineStub!
    private var userActivityReporter: CoreUserActivityReporterStub!
    private var placeAutocomplete: PlaceAutocomplete!
    private var coordinate: CLLocationCoordinate2D!

    private let options = CoreRequestOptions.sample1

    override func setUp() {
        super.setUp()

        searchEngine = CoreSearchEngineStub(accessToken: "test", location: nil)
        searchEngine.searchResponse = CoreSearchResponseStub.successSample(results: [])
        userActivityReporter = CoreUserActivityReporterStub()
        coordinate = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)

        placeAutocomplete = PlaceAutocomplete(
            searchEngine: searchEngine,
            userActivityReporter: userActivityReporter
        )
    }

    override func tearDown() {
        super.tearDown()

        searchEngine = nil
        placeAutocomplete = nil
    }

    func testSuggestionsForQuery() {
        placeAutocomplete.suggestions(for: "query", proximity: coordinate) { _ in }

        XCTAssertEqual(userActivityReporter.passedActivity, "place-autocomplete-forward-geocoding")
        XCTAssertEqual(searchEngine.query, "query")
        XCTAssertEqual(searchEngine.categories, [])
        XCTAssertEqual(searchEngine.searchOptions?.isIgnoreUR, true)
        XCTAssertEqual(searchEngine.searchOptions?.proximity?.coordinate, coordinate)
        XCTAssertEqual(searchEngine.searchOptions?.origin?.coordinate, coordinate)
        XCTAssertNil(searchEngine.searchOptions?.navProfile)
        XCTAssertNil(searchEngine.searchOptions?.etaType)
    }

    func testReverseGeocodingRequestUsesAllPlaceTypesIfTheyWereNotSpecifiedInOptions() {
        placeAutocomplete.suggestions(for: .sample1) { _ in }

        XCTAssertFalse(searchEngine.reverseGeocodingOptions!.types!.isEmpty)
        XCTAssertEqual(searchEngine.reverseGeocodingOptions!.types!.count, PlaceAutocomplete.PlaceType.allTypes.count)
    }

    func testSuggestionsRequestUsesAllPlaceTypesIfTheyWereNotSpecifiedInOptions() {
        placeAutocomplete.suggestions(for: "query") { _ in }

        XCTAssertFalse(searchEngine.searchOptions!.types!.isEmpty)
        XCTAssertEqual(searchEngine.searchOptions!.types!.count, PlaceAutocomplete.PlaceType.allTypes.count)
    }

    func testSuggestionsFilteredBy() {
        let types: [PlaceAutocomplete.PlaceType] = [.POI, .administrativeUnit(.city)]
        placeAutocomplete.suggestions(
            for: "query",
            proximity: coordinate,
            filterBy: .init(
                countries: [
                    .init(countryCode: Country.ISO3166_1_alpha2.us.rawValue)!,
                    .init(countryCode: Country.ISO3166_1_alpha2.gb.rawValue)!,
                ],
                language: .init(languageCode: Language.ISO639_1.en.rawValue),
                types: types,
                navigationProfile: .cycling
            )
        ) { _ in }

        XCTAssertEqual(userActivityReporter.passedActivity, "place-autocomplete-forward-geocoding")
        XCTAssertEqual(searchEngine.query, "query")
        XCTAssertEqual(searchEngine.categories, [])
        XCTAssertEqual(searchEngine.searchOptions?.isIgnoreUR, true)
        XCTAssertEqual(searchEngine.searchOptions?.proximity?.coordinate, coordinate)
        XCTAssertEqual(searchEngine.searchOptions?.origin?.coordinate, coordinate)
        XCTAssertEqual(searchEngine.searchOptions?.navProfile, "cycling")
        XCTAssertEqual(searchEngine.searchOptions?.etaType, "navigation")
        XCTAssertEqual(searchEngine.searchOptions?.countries, ["us", "gb"])
        XCTAssertEqual(searchEngine.searchOptions?.language, ["en"])
        XCTAssertEqual(searchEngine.searchOptions?.types, types.map { $0.coreType.coreValue.rawValue as NSNumber })
    }

    func testFilterOutCategoryAndQuerySuggestion() {
        let expectation = XCTestExpectation(description: "Call callback")
        let results = [
            CoreSearchResultStub.makePOI(),
            CoreSearchResultStub.makePlace(),
            CoreSearchResultStub.makeAddress(),
            CoreSearchResultStub.makeSuggestion(),
            CoreSearchResultStub.makeCategory(),
            CoreSearchResultStub.makeSuggestionTypeQuery(),
        ].map(\.asCoreSearchResult)
        searchEngine.searchResponse = CoreSearchResponseStub.successSample(results: results)

        placeAutocomplete.suggestions(for: "query") { result in
            switch result {
            case .success(let returnedSuggestions):
                XCTAssertEqual(returnedSuggestions.count, 4)
            case .failure:
                XCTFail("Should return success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(userActivityReporter.passedActivity, "place-autocomplete-forward-geocoding")
        XCTAssertFalse(searchEngine.nextSearchCalled)
        XCTAssertEqual(searchEngine.query, "query")
        XCTAssertEqual(searchEngine.categories, [])
        XCTAssertEqual(searchEngine.searchOptions?.isIgnoreUR, true)
    }

    func testDoNotCallRetrieveForSuggestionWithCoordinate() {
        let expectation = XCTestExpectation(description: "Call callback")
        let results = [
            CoreSearchResultStub.makePOI(),
            CoreSearchResultStub.makePlace(),
            CoreSearchResultStub.makeAddress(),
        ].map(\.asCoreSearchResult)
        searchEngine.searchResponse = CoreSearchResponseStub.successSample(results: results)
        placeAutocomplete.suggestions(for: "query") { result in
            switch result {
            case .success(let returnedSuggestions):
                XCTAssertEqual(returnedSuggestions.count, 3)
            case .failure:
                XCTFail("Should return success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(searchEngine.nextSearchCalled)
    }

    func testSelectSuggestionIfNeedToRetrieve() {
        let coreSuggestion = CoreSearchResultStub.makeSuggestion()
        coreSuggestion.resultTypes = [.poi]
        coreSuggestion.center = CLLocation(latitude: 10.0, longitude: 20.0)

        let suggestion = PlaceAutocomplete.Suggestion.makeMock(
            underlying: .suggestion(coreSuggestion, options)
        )

        let expectation = XCTestExpectation(description: "Call callback")
        placeAutocomplete.select(suggestion: suggestion) { _ in
            expectation.fulfill()
        }

        XCTAssertEqual(userActivityReporter.passedActivity, "place-autocomplete-suggestion-select")
        XCTAssertTrue(searchEngine.nextSearchCalled)
        wait(for: [expectation], timeout: 1.0)
    }

    func testSelectSuggestionIfDoNotNeedToRetrieve() {
        let suggestion = PlaceAutocomplete.Suggestion.makeMock()

        let expectation = XCTestExpectation(description: "Call callback")
        placeAutocomplete.select(suggestion: suggestion) { _ in
            expectation.fulfill()
        }

        XCTAssertEqual(userActivityReporter.passedActivity, "place-autocomplete-suggestion-select")
        XCTAssertFalse(searchEngine.nextSearchCalled)
        wait(for: [expectation], timeout: 1.0)
    }

    func testReverseGeocodingReturnsAutocompleteSuggestionsAsResults() {
        let results = [
            CoreSearchResultStub.makePlace(),
            CoreSearchResultStub.makeAddress(),
        ].map(\.asCoreSearchResult)

        searchEngine.searchResponse = CoreSearchResponseStub.successSample(results: results)

        let suggestionsExpectation = XCTestExpectation(description: "Suggestions resolved")

        placeAutocomplete.suggestions(
            for: CLLocationCoordinate2D(latitude: .zero, longitude: .zero)
        ) { result in
            suggestionsExpectation.fulfill()

            do {
                let suggestions = try result.get()
                XCTAssertEqual(suggestions.count, 2)

                for item in suggestions {
                    if case .suggestion = item.underlying {
                        XCTFail("Geocoding suggestions should be resolved as results")
                    }
                }
            } catch {
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [suggestionsExpectation], timeout: 1.0)
    }
}
