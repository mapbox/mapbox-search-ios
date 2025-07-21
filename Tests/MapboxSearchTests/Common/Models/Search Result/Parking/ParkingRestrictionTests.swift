@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingRestrictionTests: XCTestCase {
    func testConvertingFromCoreTypes() {
        XCTAssertEqual(parkingRestriction(for: .unknown), .unknown)
        XCTAssertEqual(parkingRestriction(for: .evOnly), .evOnly)
        XCTAssertEqual(parkingRestriction(for: .plugged), .plugged)
        XCTAssertEqual(parkingRestriction(for: .disabled), .disabled)
        XCTAssertEqual(parkingRestriction(for: .customers), .customers)
        XCTAssertEqual(parkingRestriction(for: .motorCycles), .motorCycles)
        XCTAssertEqual(parkingRestriction(for: .noParking), .noParking)
        XCTAssertEqual(parkingRestriction(for: .maxStay), .maxStay)
        XCTAssertEqual(parkingRestriction(for: .monthlyOnly), .monthlyOnly)
        XCTAssertEqual(parkingRestriction(for: .noSuv), .noSuv)
        XCTAssertEqual(parkingRestriction(for: .noLpg), .noLpg)
        XCTAssertEqual(parkingRestriction(for: .valetOnly), .valetOnly)
        XCTAssertEqual(parkingRestriction(for: .visitorsOnly), .visitorsOnly)
        XCTAssertEqual(parkingRestriction(for: .eventsOnly), .eventsOnly)
        XCTAssertEqual(parkingRestriction(for: .noRestrictionsOutsideHours), .noRestrictionsOutsideHours)
        XCTAssertEqual(parkingRestriction(for: .bookingOnly), .bookingOnly)
        XCTAssertEqual(parkingRestriction(for: .parkingDisk), .parkingDisk)
    }

    func parkingRestriction(for coreParkingPriceType: CoreParkingRestriction) -> ParkingRestriction {
        NSNumber(value: coreParkingPriceType.rawValue).parkingRestriction
    }
}
