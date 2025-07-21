@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingAvailabilityLevelTests: XCTestCase {
    func testConvertingFromCoreTypes() {
        XCTAssertEqual(parkingAvailabilityLevel(for: .unknown), .unknown)
        XCTAssertEqual(parkingAvailabilityLevel(for: .low), .low)
        XCTAssertEqual(parkingAvailabilityLevel(for: .mid), .mid)
        XCTAssertEqual(parkingAvailabilityLevel(for: .high), .high)
    }

    private func parkingAvailabilityLevel(for coreValue: CoreParkingAvailabilityLevel) -> ParkingAvailabilityLevel {
        NSNumber(value: coreValue.rawValue).parkingAvailabilityLevel
    }
}
