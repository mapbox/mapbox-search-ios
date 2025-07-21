@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingTrendTests: XCTestCase {
    func testConvertingFromCoreTypes() {
        XCTAssertEqual(parkingTrend(for: .unknown), .unknown)
        XCTAssertEqual(parkingTrend(for: .noChange), .noChange)
        XCTAssertEqual(parkingTrend(for: .decreasing), .decreasing)
        XCTAssertEqual(parkingTrend(for: .increasing), .increasing)
    }

    private func parkingTrend(for coreValue: CoreParkingTrend) -> ParkingTrend {
        NSNumber(value: coreValue.rawValue).parkingTrend
    }
}
