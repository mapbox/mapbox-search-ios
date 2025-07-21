@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingPaymentMethodTests: XCTestCase {
    func testConvertingFromCoreTypes() {
        XCTAssertEqual(parkingPaymentMethod(for: .unknown), .unknown)
        XCTAssertEqual(parkingPaymentMethod(for: .payOnFoot), .payOnFoot)
        XCTAssertEqual(parkingPaymentMethod(for: .payAndDisplay), .payAndDisplay)
        XCTAssertEqual(parkingPaymentMethod(for: .payOnExit), .payOnExit)
        XCTAssertEqual(parkingPaymentMethod(for: .payOnEntry), .payOnEntry)
        XCTAssertEqual(parkingPaymentMethod(for: .parkingMeter), .parkingMeter)
        XCTAssertEqual(parkingPaymentMethod(for: .multiSpaceMeter), .multiSpaceMeter)
        XCTAssertEqual(parkingPaymentMethod(for: .honestyBox), .honestyBox)
        XCTAssertEqual(parkingPaymentMethod(for: .attendant), .attendant)
        XCTAssertEqual(parkingPaymentMethod(for: .payByPlate), .payByPlate)
        XCTAssertEqual(parkingPaymentMethod(for: .payAtReception), .payAtReception)
        XCTAssertEqual(parkingPaymentMethod(for: .payByPhone), .payByPhone)
        XCTAssertEqual(parkingPaymentMethod(for: .payByCoupon), .payByCoupon)
        XCTAssertEqual(parkingPaymentMethod(for: .electronicParkingSystem), .electronicParkingSystem)
    }

    private func parkingPaymentMethod(for coreValue: CoreParkingPaymentMethod) -> ParkingPaymentMethod {
        NSNumber(value: coreValue.rawValue).parkingPaymentMethod
    }
}
