@testable import MapboxSearch
import XCTest

final class TilesetParametersTests: XCTestCase {
    var dataset = "dataset1"

    func testGeneratedDatasetNameIfOnlyDataset() {
        let parameters = TilesetParameters(dataset: dataset)
        XCTAssertEqual(parameters.generatedDatasetName, "dataset1")
    }

    @available(iOS 16.0, *)
    func testGeneratedDatasetNameIfValidLanguage() {
        let parameters1 = TilesetParameters(
            dataset: dataset,
            language: Locale.LanguageCode.english.identifier
        )
        XCTAssertEqual(parameters1.generatedDatasetName, "dataset1_en")
        let parameters2 = TilesetParameters(
            dataset: dataset,
            language: "EN"
        )
        XCTAssertEqual(parameters2.generatedDatasetName, "dataset1_en")
        let parameters3 = TilesetParameters(
            dataset: dataset,
            language: Locale.LanguageCode.chinese.identifier
        )
        XCTAssertEqual(parameters3.generatedDatasetName, "dataset1_zh")
    }

    @available(iOS 16.0, *)
    func testGeneratedDatasetNameIfInvalidLanguage() {
        let parameters1 = TilesetParameters(
            dataset: dataset,
            language: "invalid"
        )
        XCTAssertEqual(parameters1.generatedDatasetName, "dataset1")
        let parameters2 = TilesetParameters(
            dataset: dataset,
            language: Locale.Region.unitedStates.identifier
        )
        XCTAssertEqual(parameters2.generatedDatasetName, "dataset1")
    }

    @available(iOS 16.0, *)
    func testGeneratedDatasetNameIfValidLanguageAndWorldView() {
        let parameters1 = TilesetParameters(
            dataset: dataset,
            language: Locale.LanguageCode.english.identifier,
            worldview: Locale.Region.unitedStates.identifier
        )
        XCTAssertEqual(parameters1.generatedDatasetName, "dataset1_en-us")

        let parameters2 = TilesetParameters(
            dataset: dataset,
            language: Locale.LanguageCode.english.identifier,
            worldview: Locale.Region.unitedKingdom.identifier
        )
        XCTAssertEqual(parameters2.generatedDatasetName, "dataset1_en-gb")

        let parameters3 = TilesetParameters(
            dataset: dataset,
            language: Locale.LanguageCode.english.identifier,
            worldview: "gb"
        )
        XCTAssertEqual(parameters3.generatedDatasetName, "dataset1_en-gb")
    }

    @available(iOS 16.0, *)
    func testGeneratedDatasetNameIfInvalidLanguageAndWorldView() {
        let parameters1 = TilesetParameters(
            dataset: dataset,
            language: nil,
            worldview: Locale.Region.unitedStates.identifier
        )
        XCTAssertEqual(parameters1.generatedDatasetName, "dataset1")

        let parameters2 = TilesetParameters(
            dataset: dataset,
            language: "invalid",
            worldview: Locale.Region.unitedKingdom.identifier
        )
        XCTAssertEqual(parameters2.generatedDatasetName, "dataset1")

        let parameters3 = TilesetParameters(
            dataset: dataset,
            language: Locale.LanguageCode.english.identifier,
            worldview: "invalid"
        )
        XCTAssertEqual(parameters3.generatedDatasetName, "dataset1_en")
    }
}
