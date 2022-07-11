// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class AddressAutofillOptionsTests: XCTestCase {
    func testThatDefaultOptionsAreCorrect() {
        let options = AddressAutofill.Options()
        
        XCTAssertTrue(options.countries.isEmpty)
        XCTAssertEqual(options.language, .default)
    }
    
    func testThatOptionsInitializedWithCountries() {
        let countries = [
            Country(countryCode: Country.ISO3166_1_alpha1.fr.rawValue),
            Country(countryCode: Country.ISO3166_1_alpha1.de.rawValue),
            Country(countryCode: Country.ISO3166_1_alpha1.us.rawValue)
        ].compactMap { $0 }
        
        XCTAssertEqual(countries.count, 3)
        
        let options = AddressAutofill.Options(countries: countries)
        XCTAssertEqual(countries, options.countries)
    }
    
    func testThatOptionsInitializedWithLanguage() {
        let language = Language(languageCode: Language.ISO639_1.fr.rawValue)!
        
        let options = AddressAutofill.Options(language: language)
        
        XCTAssertEqual(options.language, language)
    }
}
