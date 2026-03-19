import MapboxCoreSearch
@testable import MapboxSearch
import XCTest

final class ReverseGeocodingOptionsTests: XCTestCase {
    @available(*, deprecated)
    func testFilterQueryTypes() {
        var options = ReverseGeocodingOptions(point: .sample1, types: [.district, .place])
        XCTAssertEqual(options.filterQueryTypes, [.district, .place])
        XCTAssertEqual(options.types, [.district, .place])

        options.types = [.address]
        XCTAssertEqual(options.filterQueryTypes, [.address])
        XCTAssertEqual(options.types, [.address])

        options.filterQueryTypes = [.brand]
        XCTAssertEqual(options.filterQueryTypes, [.brand])
        XCTAssertEqual(options.types, [.poi])
    }

    func testToCore() {
        let options = ReverseGeocodingOptions(
            point: .sample1,
            mode: .score,
            limit: 11,
            filterQueryTypes: [.brand, .district, .place],
            countries: ["US", "BY", "DE"],
            languages: ["en"]
        )

        let coreOptions = options.toCore()
        let expectedTypes = [CoreQueryType.brand, .district, .place].map { NSNumber(value: $0.rawValue) }
        XCTAssertEqual(coreOptions.point, options.point)
        XCTAssertEqual(coreOptions.reverseMode, NSNumber(value: ReverseMode.score.rawValue))
        XCTAssertEqual(coreOptions.countries, options.countries)
        XCTAssertEqual(coreOptions.language, options.languages)
        XCTAssertEqual(coreOptions.limit, 11)
        XCTAssertEqual(coreOptions.types, expectedTypes)
    }
}
