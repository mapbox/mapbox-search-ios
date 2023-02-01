// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
import CoreLocation

@testable import MapboxSearch

final class PlaceAutocompleteQueryTests: XCTestCase {
    func testThatTextQueryIsNotInitializedWithIncorrectValue() {
        XCTAssertNil(PlaceAutocomplete.TextQuery(value: ""))
        XCTAssertNotNil(PlaceAutocomplete.TextQuery(value: "1"))
    }
    
    func testThatTextQueryIsInitializedWithCorrectValue() {
        let query = PlaceAutocomplete.TextQuery(value: "123")
        
        XCTAssertNotNil(query)
        XCTAssertEqual(query?.value, "123")
    }
    
    func testThatTextQueryStoresBoundingBox() {
        let query = PlaceAutocomplete.TextQuery(value: "123", boundingBox: .sample1)
        
        XCTAssertNotNil(query)
        XCTAssertEqual(query?.value, "123")
        XCTAssertEqual(query?.boundingBox, .sample1)
    }
    
    func testThatCoordinateQueryIsNotInitializedWithIncorrectValue() {
        let invalidCoordinates = kCLLocationCoordinate2DInvalid
        XCTAssertNil(PlaceAutocomplete.CoordinateQuery(coordinate: invalidCoordinates))
    }
    
    func testThatCoordinateQueryIsInitializedWithCorrectValue() {
        let validCoordinates = CLLocationCoordinate2D(
            latitude: 38.8951,
            longitude: -77.0364
        )
        
        let query = PlaceAutocomplete.CoordinateQuery(
            coordinate: validCoordinates
        )

        XCTAssertNotNil(query)
        XCTAssertEqual(query?.coordinate, validCoordinates)
    }
}
