@testable import MapboxSearch
import XCTest

final class LanguageTests: XCTestCase {
    func testThatLanguageIsInitializedWithCorrectIdentifier() {
        let uppercasedIdentifier = Language(languageCode: "EN")
        let lowercasedIdentifier = Language(languageCode: "en")

        XCTAssertNotNil(uppercasedIdentifier)
        XCTAssertTrue(uppercasedIdentifier?.languageCode == "en")

        XCTAssertNotNil(lowercasedIdentifier)
        XCTAssertTrue(lowercasedIdentifier?.languageCode == "en")
    }

    func testThatLanguageIsNotInitializedWithIncorrectIdentifier() {
        let invalidIdentifier = Language(languageCode: "invalid")

        XCTAssertNil(invalidIdentifier)
    }

    func testThatLanguageCanBeInitializedFromLocale() {
        [
            Locale(identifier: "en-US"),
            Locale(identifier: "en"),
            Locale(identifier: "en-UK"),
        ].forEach { locale in
            XCTAssertNotNil(locale)

            let language = Language(locale: locale)

            XCTAssertNotNil(language)
            XCTAssertEqual(language?.languageCode, locale.languageCode)
        }
    }
}
