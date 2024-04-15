import CoreLocation
@testable import MapboxSearch
import XCTest

final class PlaceAutocompleteIntegrationTests: MockServerIntegrationTestCase<SBSMockResponse> {
    private var placeAutocomplete: PlaceAutocomplete!

    override func setUp() {
        super.setUp()

        let reporter = CoreUserActivityReporter.getOrCreate(
            for: CoreUserActivityReporterOptions(
                accessToken: "access-token",
                userAgent: "mapbox-search-ios-tests",
                eventsUrl: nil
            )
        )

        let engine = LocalhostMockServiceProvider.shared.createEngine(
            apiType: Mock.coreApiType,
            accessToken: "access-token",
            locationProvider: WrapperLocationProvider(wrapping: DefaultLocationProvider())
        )

        placeAutocomplete = PlaceAutocomplete(
            searchEngine: engine,
            userActivityReporter: reporter
        )
    }

    func testSelectSuggestionsAllWithoutCoordinate() throws {
        let expectation = XCTestExpectation(description: "Expecting results")

        try server.setResponse(.suggestSanFrancisco)
        try server.setResponse(.retrieveSanFrancisco)

        var suggestion: PlaceAutocomplete.Suggestion?
        placeAutocomplete.suggestions(for: "San Francisco") { result in
            switch result {
            case .success(let suggestions):
                XCTAssertEqual(suggestions.count, 10)
                XCTAssertTrue(suggestions.allSatisfy { suggestion in
                    if case .suggestion = suggestion.underlying { return true }
                    return false
                })
                suggestion = suggestions[0]
            case .failure:
                XCTFail("Should return success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

        let selectionExpectation = XCTestExpectation(description: "Expecting selection result")
        placeAutocomplete.select(suggestion: suggestion!) { result in
            switch result {
            case .success(let resolvedSuggestion):
                XCTAssertEqual(resolvedSuggestion.name, "San Francisco")
                XCTAssertEqual(resolvedSuggestion.description, "California, United States")
                XCTAssertEqual(
                    resolvedSuggestion.coordinate,
                    CLLocationCoordinate2D(latitude: 37.7648, longitude: -122.463)
                )
            case .failure:
                XCTFail("Should return success")
            }
            selectionExpectation.fulfill()
        }

        wait(for: [selectionExpectation], timeout: 5)
    }

    func testSelectSuggestionsAllWithCoordinate() throws {
        let expectation = XCTestExpectation(description: "Expecting results")

        try server.setResponse(.suggestWithCoordinates)

        var suggestion: PlaceAutocomplete.Suggestion?
        placeAutocomplete.suggestions(for: "query") { result in
            switch result {
            case .success(let suggestions):
                XCTAssertEqual(suggestions.count, 3)
                XCTAssertTrue(suggestions.allSatisfy { suggestion in
                    if case .suggestion = suggestion.underlying { return true }
                    return false
                })
                guard case .suggestion(let coreSuggestion, _) = suggestions[0].underlying else {
                    XCTFail("Not expected underlying type")
                    return
                }
                suggestion = suggestions[0]
                let coordinate = CLLocationCoordinate2D(latitude: 38.900017, longitude: -77.032161)
                XCTAssertEqual(coreSuggestion.center?.coordinate, coordinate)
                XCTAssertEqual(suggestion?.coordinate, coordinate)
                let point = RoutablePoint(
                    name: "POI",
                    point: CLLocationCoordinate2DCodable(latitude: 38.900017, longitude: -77.032161)
                )
                XCTAssertEqual(suggestion?.routablePoints, [point])
            case .failure:
                XCTFail("Should return success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

        try server.setResponse(.retrieveMinsk)
        let selectionExpectation = XCTestExpectation(description: "Expecting selection result")
        placeAutocomplete.select(suggestion: suggestion!) { result in
            switch result {
            case .success(let resolvedSuggestion):
                XCTAssertEqual(resolvedSuggestion.name, "Minsk")
                XCTAssertEqual(resolvedSuggestion.description, "Belarus")
                XCTAssertEqual(
                    resolvedSuggestion.coordinate,
                    CLLocationCoordinate2D(latitude: 53.90225, longitude: 27.56184)
                )
            case .failure:
                XCTFail("Should return success")
            }
            selectionExpectation.fulfill()
        }

        wait(for: [selectionExpectation], timeout: 5)
    }

    func testSelectSuggestionsIfSomeWithCoordinates() throws {
        let expectation = XCTestExpectation(description: "Expecting results")

        try server.setResponse(.suggestWithMixedCoordinates)
        try server.setResponse(.retrievePoi)

        var actualSuggestions: [PlaceAutocomplete.Suggestion] = []

        placeAutocomplete.suggestions(for: "query") { result in
            switch result {
            case .success(let suggestions):
                XCTAssertEqual(suggestions.count, 3)
                guard case .suggestion = suggestions[0].underlying else {
                    XCTFail("First without coordinate should be retrieved and have empty value")
                    return
                }
                guard case .suggestion = suggestions[1].underlying else {
                    XCTFail("Second with coordinate should not be retrieved")
                    return
                }
                guard case .suggestion = suggestions[2].underlying else {
                    XCTFail("Third with coordinate should not be retrieved")
                    return
                }
                XCTAssertEqual(suggestions[1].name, "Starbucks")
                XCTAssertEqual(
                    suggestions[1].description,
                    "901 15th St NW, Washington, District of Columbia 20005, United States of America"
                )
                XCTAssertEqual(
                    suggestions[1].coordinate,
                    CLLocationCoordinate2D(latitude: 38.90143, longitude: -77.033568)
                )
                let point = RoutablePoint(
                    name: "POI",
                    point: CLLocationCoordinate2DCodable(latitude: 38.90143, longitude: -77.033568)
                )
                XCTAssertEqual(suggestions[1].routablePoints, [point])
                actualSuggestions = suggestions
            case .failure:
                XCTFail("Should return success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

        let firstSuggestion = try XCTUnwrap(actualSuggestions[0])
        XCTAssertNil(firstSuggestion.coordinate)

        let selectionExpectation = XCTestExpectation(description: "Expecting selection result")
        XCTAssertEqual(actualSuggestions.count, 3)
        placeAutocomplete.select(suggestion: actualSuggestions[1]) { result in
            switch result {
            case .success(let resolvedSuggestion):
                XCTAssertEqual(resolvedSuggestion.name, "Starbucks")
                XCTAssertEqual(
                    resolvedSuggestion.description,
                    "901 15th St NW, Washington, District of Columbia 20005, United States of America"
                )
                XCTAssertEqual(resolvedSuggestion.phone, "+1 123-456-789")
                XCTAssertEqual(
                    resolvedSuggestion.coordinate,
                    CLLocationCoordinate2D(latitude: 38.90143, longitude: -77.033568)
                )
            case .failure:
                XCTFail("Should return success")
            }
            selectionExpectation.fulfill()
        }

        wait(for: [selectionExpectation], timeout: 5)
    }

    func testIgnoresCategoryAndQuerySuggestions() throws {
        let expectation = XCTestExpectation(description: "Expecting results")

        try server.setResponse(.suggestCategoryWithCoordinates)
        try server.setResponse(.retrieveMinsk)

        var suggestion: PlaceAutocomplete.Suggestion?
        placeAutocomplete.suggestions(for: "query") { result in
            switch result {
            case .success(let suggestions):
                XCTAssertEqual(suggestions.count, 1)
                XCTAssertTrue(suggestions.allSatisfy { suggestion in
                    if case .suggestion = suggestion.underlying { return true }
                    return false
                })
                guard case .suggestion(let coreSuggestion, _) = suggestions[0].underlying else {
                    XCTFail("Not expected underlying type")
                    return
                }
                suggestion = suggestions[0]
                let coordinate = CLLocationCoordinate2D(latitude: 38.900017, longitude: -77.032161)
                XCTAssertEqual(coreSuggestion.center?.coordinate, coordinate)
                XCTAssertEqual(suggestion?.coordinate, coordinate)
                let point = RoutablePoint(
                    name: "POI",
                    point: CLLocationCoordinate2DCodable(latitude: 38.900017, longitude: -77.032161)
                )
                XCTAssertEqual(suggestion?.routablePoints, [point])
                XCTAssertEqual(suggestion?.name, "Starbucks")
                XCTAssertEqual(
                    suggestion?.description,
                    "1401 New York Ave NW, Washington, District of Columbia 20005, United States of America"
                )
            case .failure:
                XCTFail("Should return success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

        try server.setResponse(.retrievePoi)
        let selectionExpectation = XCTestExpectation(description: "Expecting selection result")
        placeAutocomplete.select(suggestion: suggestion!) { result in
            switch result {
            case .success(let resolvedSuggestion):
                XCTAssertEqual(resolvedSuggestion.name, "Starbucks")
                XCTAssertEqual(
                    resolvedSuggestion.description,
                    "901 15th St NW, Washington, District of Columbia 20005, United States of America"
                )
                XCTAssertEqual(resolvedSuggestion.phone, "+1 123-456-789")
                XCTAssertEqual(
                    resolvedSuggestion.coordinate,
                    CLLocationCoordinate2D(latitude: 38.90143, longitude: -77.033568)
                )
            case .failure:
                XCTFail("Should return success")
            }
            selectionExpectation.fulfill()
        }

        wait(for: [selectionExpectation], timeout: 5)
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
