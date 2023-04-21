// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class PlaceAutocompleteTests: XCTestCase {
    private var searchEngine: CoreSearchEngineStub!
    private var userActivityReporter: CoreUserActivityReporterStub!
    private var placeAutocomplete: PlaceAutocomplete!

    private let options = CoreRequestOptions.sample1

    override func setUp() {
        super.setUp()

        searchEngine = CoreSearchEngineStub(accessToken: "test", location: nil)
        searchEngine.searchResponse = CoreSearchResponseStub.successSample(results: [])
        userActivityReporter = CoreUserActivityReporterStub()

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
        placeAutocomplete.suggestions(for: "query") { _ in }

        XCTAssertEqual(userActivityReporter.passedActivity, "place-autocomplete-forward-geocoding")
        XCTAssertEqual(searchEngine.query, "query")
        XCTAssertEqual(searchEngine.categories, [])
        XCTAssertEqual(searchEngine.searchOptions?.isIgnoreUR, true)
    }

    func testFilterOutCategoryAndQuerySuggestion() {
        let expectation = XCTestExpectation(description: "Call callback")
        let results = [
            CoreSearchResultStub.makePOI(),
            CoreSearchResultStub.makePlace(),
            CoreSearchResultStub.makeAddress(),
            CoreSearchResultStub.makeSuggestion(),
            CoreSearchResultStub.makeCategory(),
            CoreSearchResultStub.makeSuggestionTypeQuery()
        ].map { $0.asCoreSearchResult }
        searchEngine.searchResponse = CoreSearchResponseStub.successSample(results: results)

        let retrieveResults = [CoreSearchResultStub.makePOI().asCoreSearchResult]
        searchEngine.nextSearchResponse = CoreSearchResponseStub.successSample(results: retrieveResults)

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
        XCTAssertTrue(searchEngine.nextSearchCalled)
        XCTAssertEqual(searchEngine.query, "query")
        XCTAssertEqual(searchEngine.categories, [])
        XCTAssertEqual(searchEngine.searchOptions?.isIgnoreUR, true)
    }

    func testDoNotCallRetrieveForSuggestionWithCoordinate() {
        let expectation = XCTestExpectation(description: "Call callback")
        let results = [
            CoreSearchResultStub.makePOI(),
            CoreSearchResultStub.makePlace(),
            CoreSearchResultStub.makeAddress()
        ].map { $0.asCoreSearchResult }
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

    func testSelectSuggestionIfNeedToRetrive() {
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

    func testSelectSuggestionIfDoNotNeedToRetrive() {
        let suggestion = PlaceAutocomplete.Suggestion.makeMock()

        let expectation = XCTestExpectation(description: "Call callback")
        placeAutocomplete.select(suggestion: suggestion) { _ in
            expectation.fulfill()
        }

        XCTAssertEqual(userActivityReporter.passedActivity, "place-autocomplete-suggestion-select")
        XCTAssertFalse(searchEngine.nextSearchCalled)
        wait(for: [expectation], timeout: 1.0)
    }
}
