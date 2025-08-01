@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingRateValueTests: XCTestCase {
    func testConvertingFromCoreTypesIfNSString() {
        let coreValue = CoreParkingRateValue.fromNSString("value_string")
        XCTAssertEqual(coreValue.parkingRateValue, .iso8601DurationFormat("value_string"))
    }

    func testConvertingFromCoreTypesIfCustom() {
        XCTAssertEqual(parkingRateValue(for: .sixMonthsMonFri), .customValue(.sixMonthsMonFri))
        XCTAssertEqual(parkingRateValue(for: .bankHoliday), .customValue(.bankHoliday))
        XCTAssertEqual(parkingRateValue(for: .daytime), .customValue(.daytime))
        XCTAssertEqual(parkingRateValue(for: .earlyBird), .customValue(.earlyBird))
        XCTAssertEqual(parkingRateValue(for: .evening), .customValue(.evening))
        XCTAssertEqual(parkingRateValue(for: .flatRate), .customValue(.flatRate))
        XCTAssertEqual(parkingRateValue(for: .max), .customValue(.max))
        XCTAssertEqual(parkingRateValue(for: .maxOnlyOnce), .customValue(.maxOnlyOnce))
        XCTAssertEqual(parkingRateValue(for: .minimum), .customValue(.minimum))
        XCTAssertEqual(parkingRateValue(for: .month), .customValue(.month))
        XCTAssertEqual(parkingRateValue(for: .monthMonFri), .customValue(.monthMonFri))
        XCTAssertEqual(parkingRateValue(for: .monthReserved), .customValue(.monthReserved))
        XCTAssertEqual(parkingRateValue(for: .monthUnreserved), .customValue(.monthUnreserved))
        XCTAssertEqual(parkingRateValue(for: .overnight), .customValue(.overnight))
        XCTAssertEqual(parkingRateValue(for: .quarterMonFri), .customValue(.quarterMonFri))
        XCTAssertEqual(parkingRateValue(for: .untilClosing), .customValue(.untilClosing))
        XCTAssertEqual(parkingRateValue(for: .weekend), .customValue(.weekend))
        XCTAssertEqual(parkingRateValue(for: .yearMonFri), .customValue(.yearMonFri))
    }

    private func parkingRateValue(for coreValue: CoreParkingRateCustomValue) -> ParkingRateValue? {
        CoreParkingRateValue.fromParkingRateCustomValue(coreValue).parkingRateValue
    }
}
