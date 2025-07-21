@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingRateCustomValueTests: XCTestCase {
    func testConvertingFromCoreTypes() {
        XCTAssertEqual(parkingRateCustomValue(for: .sixMonthsMonFri), .sixMonthsMonFri)
        XCTAssertEqual(parkingRateCustomValue(for: .bankHoliday), .bankHoliday)
        XCTAssertEqual(parkingRateCustomValue(for: .daytime), .daytime)
        XCTAssertEqual(parkingRateCustomValue(for: .earlyBird), .earlyBird)
        XCTAssertEqual(parkingRateCustomValue(for: .evening), .evening)
        XCTAssertEqual(parkingRateCustomValue(for: .flatRate), .flatRate)
        XCTAssertEqual(parkingRateCustomValue(for: .max), .max)
        XCTAssertEqual(parkingRateCustomValue(for: .maxOnlyOnce), .maxOnlyOnce)
        XCTAssertEqual(parkingRateCustomValue(for: .minimum), .minimum)
        XCTAssertEqual(parkingRateCustomValue(for: .month), .month)
        XCTAssertEqual(parkingRateCustomValue(for: .monthMonFri), .monthMonFri)
        XCTAssertEqual(parkingRateCustomValue(for: .monthReserved), .monthReserved)
        XCTAssertEqual(parkingRateCustomValue(for: .monthUnreserved), .monthUnreserved)
        XCTAssertEqual(parkingRateCustomValue(for: .overnight), .overnight)
        XCTAssertEqual(parkingRateCustomValue(for: .quarterMonFri), .quarterMonFri)
        XCTAssertEqual(parkingRateCustomValue(for: .untilClosing), .untilClosing)
        XCTAssertEqual(parkingRateCustomValue(for: .weekend), .weekend)
        XCTAssertEqual(parkingRateCustomValue(for: .yearMonFri), .yearMonFri)
    }

    private func parkingRateCustomValue(for coreValue: CoreParkingRateCustomValue) -> ParkingRateCustomValue {
        coreValue.parkingRateCustomValue
    }
}
