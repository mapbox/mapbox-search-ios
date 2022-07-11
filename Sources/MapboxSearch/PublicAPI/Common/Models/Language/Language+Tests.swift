// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

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
}
