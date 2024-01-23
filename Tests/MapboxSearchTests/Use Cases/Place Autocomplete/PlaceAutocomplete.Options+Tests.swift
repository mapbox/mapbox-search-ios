@testable import MapboxSearch
import XCTest

final class PlaceAutocompleteOptionsTests: XCTestCase {
    func testThatDefaultOptionsAreCorrect() {
        let options = PlaceAutocomplete.Options()

        XCTAssertTrue(options.countries.isEmpty)
        XCTAssertTrue(options.types.isEmpty)

        XCTAssertEqual(options.language, .default)
    }

    func testThatOptionsInitializedWithCountries() {
        let countries = [
            Country(countryCode: Country.ISO3166_1_alpha2.fr.rawValue),
            Country(countryCode: Country.ISO3166_1_alpha2.de.rawValue),
            Country(countryCode: Country.ISO3166_1_alpha2.us.rawValue),
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
        let placeTypes: [PlaceAutocomplete.PlaceType] = [
            .administrativeUnit(.region), .administrativeUnit(.address), .administrativeUnit(.chome),
        ]

        let options = PlaceAutocomplete.Options(types: placeTypes)

        XCTAssertEqual(options.types, placeTypes)
    }
}
