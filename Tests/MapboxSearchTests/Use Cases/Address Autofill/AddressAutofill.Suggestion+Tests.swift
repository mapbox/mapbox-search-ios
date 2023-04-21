// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class AddressAutofillSuggestionsTests: XCTestCase {
    func testThatMappingFromSearchAddressThrowsErrorOfCaseIfEmptyAddress() {
        let searchResult = SearchResultStub.default
        
        XCTAssertThrowsError(
            try AddressAutofill.Suggestion.from(searchResult),
            "Autofill.Suggestion objects can't be created with an empty address"
        ) { errorThrown in
            XCTAssertEqual(errorThrown as? AddressAutofill.Suggestion.Error, .emptyAddress)
        }
    }
    
    func testThatMappingFromSearchAddressThrowsErrorInCaseOfEmptyFormattedAddress() {
        let searchResult = SearchResultStub.default
        searchResult.address = .invalid
        
        XCTAssertThrowsError(
            try AddressAutofill.Suggestion.from(searchResult),
            "Autofill.Suggestion objects can't be created with an incorrect address"
        ) { errorThrown in
            XCTAssertEqual(errorThrown as? AddressAutofill.Suggestion.Error, .incorrectFormattedAddress)
        }
    }
    
    func testThatMappingFromSearchAddressThrowsErrorInCaseOfInvalidCoordinates() {
        let searchResult = SearchResultStub.default
        searchResult.address = .valid
        searchResult.coordinate = kCLLocationCoordinate2DInvalid
        
        XCTAssertThrowsError(
            try AddressAutofill.Suggestion.from(searchResult),
            "Autofill.Suggestion objects can't be created with invalid coordinates"
        ) { errorThrown in
            XCTAssertEqual(errorThrown as? AddressAutofill.Suggestion.Error, .invalidCoordinates)
        }
    }
    
    func testMappingFromSearchResultWithValidAddress() {
        let coordinates = CLLocationCoordinate2D(latitude: 90, longitude: 90)
        
        let searchResult = SearchResultStub.default
        searchResult.address = .valid
        searchResult.coordinate = coordinates
        
        let suggestion = try! AddressAutofill.Suggestion.from(searchResult)
        
        XCTAssertEqual(suggestion.formattedAddress, Address.valid.formattedAddress(style: .full))
        XCTAssertEqual(suggestion.coordinate, coordinates)
    }
    
    func testMappingOfAddressComponentFromSearchResultWithValidAddress() {
        let coordinates = CLLocationCoordinate2D(latitude: 90, longitude: 90)
        
        let searchResult = SearchResultStub.default
        searchResult.address = .valid
        searchResult.coordinate = coordinates
        
        let result = try! AddressAutofill.Suggestion.from(searchResult).result()
        
        XCTAssertEqual(result.addressComponents.all.count, AddressAutofill.AddressComponent.Kind.allCases.count)
        
        let addressComponentCheck: (AddressAutofill.AddressComponent, AddressAutofill.AddressComponent.Kind) -> Void = { candidate, match in
            XCTAssertEqual(candidate.kind, match)
            XCTAssertEqual(candidate.value, match.rawValue)
        }
        
        result.addressComponents.all.forEach { addressComponent in
            switch addressComponent.kind {
            case .locality:
                addressComponentCheck(addressComponent, .locality)
                
            case .neighborhood:
                addressComponentCheck(addressComponent, .neighborhood)
                
            case .country:
                addressComponentCheck(addressComponent, .country)
                
            case .houseNumber:
                addressComponentCheck(addressComponent, .houseNumber)
                
            case .postcode:
                addressComponentCheck(addressComponent, .postcode)
                
            case .place:
                addressComponentCheck(addressComponent, .place)
                
            case .district:
                addressComponentCheck(addressComponent, .district)
                
            case .street:
                addressComponentCheck(addressComponent, .street)
                
            case .region:
                addressComponentCheck(addressComponent, .region)
            }
        }
    }
}

// MARK: - Address
private extension Address {
    static var invalid: Address {
        Address(
            houseNumber: nil,
            street: nil,
            neighborhood: nil,
            locality: nil,
            postcode: nil,
            place: nil,
            district: nil,
            region: nil,
            country: nil
        )
    }

    static var valid: Address {
        Address(
            houseNumber: "houseNumber",
            street: "street",
            neighborhood: "neighborhood",
            locality: "locality",
            postcode: "postcode",
            place: "place",
            district: "district",
            region: "region",
            country: "country"
        )
    }
}
