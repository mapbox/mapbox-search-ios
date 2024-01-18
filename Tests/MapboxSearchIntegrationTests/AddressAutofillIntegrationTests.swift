import XCTest
import CoreLocation
@testable import MapboxSearch

final class AddressAutofillIntegrationTests: MockServerTestCase {
    private var addressAutofill: AddressAutofill!

    override func setUp() {
        super.setUp()

        addressAutofill = AddressAutofill(
            accessToken: "access-token",
            locationProvider: DefaultLocationProvider()
        )
    }

    func testSelectSuggestion() throws {
        let expectation = XCTestExpectation(description: "Expecting results")

        try server.setResponse(.suggestAddressSanFrancisco)
        try server.setResponse(.retrieveAddressSanFrancisco)

        var suggestion: AddressAutofill.Suggestion?
        addressAutofill.suggestions(for: .init(value: "query")!) { result in
            switch result {
            case .success(let suggestions):
                XCTAssertEqual(suggestions.count, 8)
                suggestion = suggestions.first
                suggestion = suggestions[0]
            case .failure:
                XCTFail("Should return success")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

        let expectedAddress = Address(
            houseNumber: "701",
            street: "Steiner Street",
            neighborhood: nil,
            locality: nil,
            postcode: "94117",
            place: "San Francisco",
            district: nil,
            region: "California",
            country: "United States"
        )
        let expectedAddressComponents = try expectedAddress.toAutofillComponents()

        let actualSuggestion = try! XCTUnwrap(suggestion, "Should return non-nil suggestion")

        let selectionExpectation = XCTestExpectation(description: "Expecting selection result")

        addressAutofill.select(suggestion: actualSuggestion) { result in
            switch result {
            case .success(let resolvedSuggestion):
                XCTAssertEqual(resolvedSuggestion.name, "701 Steiner Street")
                XCTAssertEqual(resolvedSuggestion.formattedAddress, expectedAddress.formattedAddress(style: .full))
                XCTAssertEqual(
                    resolvedSuggestion.coordinate,
                    CLLocationCoordinate2D(latitude: 37.784592, longitude: -122.434671)
                )
                XCTAssertEqual(resolvedSuggestion.addressComponents, expectedAddressComponents)
            case .failure:
                XCTFail("Should return success")
            }
            selectionExpectation.fulfill()
        }

        wait(for: [selectionExpectation], timeout: 5)
    }

    func testSelectSuggestionFromCoordinate() throws {
        let expectation = XCTestExpectation(description: "Expecting results")

        try server.setResponse(.retrieveAddressSanFrancisco)

        var suggestion: AddressAutofill.Suggestion?
        let query = CLLocationCoordinate2D(latitude: 37.784592, longitude: -122.434671)
        addressAutofill.suggestions(for: query)  { result in
            switch result {
            case .success(let success):
                XCTAssertEqual(success.first?.name, "701 Steiner Street")
                XCTAssertEqual(success.first?.coordinate, query)
                suggestion = success.first
            case .failure(let failure):
                XCTFail(failure.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        let expectedAddress = Address(
            houseNumber: "701",
            street: "Steiner Street",
            neighborhood: nil,
            locality: nil,
            postcode: "94117",
            place: "San Francisco",
            district: nil,
            region: "California",
            country: "United States"
        )
        let expectedAddressComponents = try! expectedAddress.toAutofillComponents()

        let actualSuggestion = try! XCTUnwrap(suggestion, "Should return non-nil suggestion")

        let selectionExpectation = XCTestExpectation(description: "Expecting selection result")

        addressAutofill.select(suggestion: actualSuggestion) { result in
            switch result {
            case .success(let resolvedSuggestion):
                XCTAssertEqual(resolvedSuggestion.name, "701 Steiner Street")
                XCTAssertEqual(resolvedSuggestion.formattedAddress, expectedAddress.formattedAddress(style: .full))
                XCTAssertEqual(
                    resolvedSuggestion.coordinate,
                    CLLocationCoordinate2D(latitude: 37.784592, longitude: -122.434671)
                )
                XCTAssertEqual(resolvedSuggestion.addressComponents, expectedAddressComponents)
            case .failure:
                XCTFail("Should return success")
            }
            selectionExpectation.fulfill()
        }

        wait(for: [selectionExpectation], timeout: 5)
    }
}

extension NonEmptyArray: Equatable where T: Equatable {
    public static func == (lhs: MapboxSearch.NonEmptyArray<T>, rhs: MapboxSearch.NonEmptyArray<T>) -> Bool {
        lhs.all == rhs.all
    }
}
