@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingPriceTypeTests: XCTestCase {
    func testConvertingFromCoreTypes() {
        XCTAssertEqual(parkingPriceType(for: .duration), .duration)
        XCTAssertEqual(parkingPriceType(for: .durationAdditional), .durationAdditional)
        XCTAssertEqual(parkingPriceType(for: .custom), .custom)
    }

    private func parkingPriceType(for coreParkingPriceType: CoreParkingPriceType) -> ParkingPriceType {
        NSNumber(value: coreParkingPriceType.rawValue).parkingPriceType
    }
}
