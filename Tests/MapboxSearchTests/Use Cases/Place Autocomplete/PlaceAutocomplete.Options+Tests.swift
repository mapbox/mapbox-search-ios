// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class PlaceAutocompleteOptionsTests: XCTestCase {
    func testThatDefaultOptionsAreCorrect() {
        let options = PlaceAutocomplete.Options()
        
        XCTAssertTrue(options.countries.isEmpty)
        XCTAssertEqual(options.language, .default)
        XCTAssertTrue(options.administrativeUnits.isEmpty)
    }
    
    func testThatOptionsInitializedWithCountries() {
        let countries = [
            Country(countryCode: Country.ISO3166_1_alpha2.fr.rawValue),
            Country(countryCode: Country.ISO3166_1_alpha2.de.rawValue),
            Country(countryCode: Country.ISO3166_1_alpha2.us.rawValue)
        ].compactMap { $0 }
        
        XCTAssertEqual(countries.count, 3)
        
        let options = PlaceAutocomplete.Options(countries: countries)
        XCTAssertEqual(countries, options.countries)
    }
    
    func testThatOptionsInitializedWithLanguage() {
        let language = Language(languageCode: Language.ISO639_1.fr.rawValue)!
        
        let options = PlaceAutocomplete.Options(language: language)
        
        XCTAssertEqual(options.language, language)
    }
    
    func testThatOptionsInitializedWithAdministrativeTypes() {
        let administrativeUnits: [AdministrativeUnit] = [.address, .street, .Japan.prefecture]
        
        let options = PlaceAutocomplete.Options(administrativeUnits: administrativeUnits)
        
        XCTAssertEqual(options.administrativeUnits, administrativeUnits)
    }
}
