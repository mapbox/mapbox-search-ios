@testable import MapboxSearch
import XCTest

class HighlightsCalculatorTests: XCTestCase {
    func testSingleHighlight() throws {
        let highlightRanges = HighlightsCalculator.calculate(for: "name", in: "name-for-test")

        XCTAssertEqual(highlightRanges, [NSRange(location: 0, length: 4)])
    }

    func testDoubleNameSingleHighlight() {
        let highlightRanges = HighlightsCalculator.calculate(for: "name", in: "name-for-test-with-name")

        XCTAssertEqual(highlightRanges, [NSRange(location: 0, length: 4)])
    }

    func testNormalizedHighlightFor_ß() {
        let highlightRanges = HighlightsCalculator.calculate(
            for: "Hohenzollernstrasse",
            in: "Some Test Hohenzollernstraße"
        )

        XCTAssertEqual(highlightRanges, [NSRange(location: 10, length: 18)])
    }

    func testNormalizedHighlightFor_Ü() {
        let highlightRanges = HighlightsCalculator.calculate(for: "munchen", in: "Förderschule in München")

        XCTAssertEqual(highlightRanges, [NSRange(location: 16, length: 7)])
    }

    func testNormalizedHighlightWithZeroMistakesFor_Ü() {
        let highlightRanges = HighlightsCalculator.calculate(for: "munchen", in: "München")
        // Core Response: [0, 7]

        XCTAssertEqual(highlightRanges, [NSRange(location: 0, length: 7)])
    }

    func testNormalizedHighlightWithOneMistakeFor_Ü() {
        let highlightRanges = HighlightsCalculator.calculate(for: "munchen", in: "FMünchen")
        // Core Response: [0, 8]

        // CoreSearchEngine corrects as max as 1 mistake in the query to match a word
        XCTAssertEqual(highlightRanges, [NSRange(location: 0, length: 8)])
    }

    func testNormalizedHighlightWithTwoMistakesFor_Ü() {
        let highlightRanges = HighlightsCalculator.calculate(for: "munchen", in: "42München")
        // Core Response: []

        XCTAssertEqual(highlightRanges, [])
    }
}
