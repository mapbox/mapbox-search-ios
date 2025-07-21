import XCTest
@_spi(Experimental) @testable import MapboxSearch

final class ParkingPaymentTypeTests: XCTestCase {
    func testConvertingFromCoreTypes() {
        XCTAssertEqual(parkingPaymentType(for: .unknown), .unknown)
        XCTAssertEqual(parkingPaymentType(for: .coins), .coins)
        XCTAssertEqual(parkingPaymentType(for: .notes), .notes)
        XCTAssertEqual(parkingPaymentType(for: .contactless), .contactless)
        XCTAssertEqual(parkingPaymentType(for: .cards), .cards)
        XCTAssertEqual(parkingPaymentType(for: .mobile), .mobile)
        XCTAssertEqual(parkingPaymentType(for: .cardsVisa), .cardsVisa)
        XCTAssertEqual(parkingPaymentType(for: .cardsMastercard), .cardsMastercard)
        XCTAssertEqual(parkingPaymentType(for: .cardsAmex), .cardsAmex)
        XCTAssertEqual(parkingPaymentType(for: .cardsMaestro), .cardsMaestro)
        XCTAssertEqual(parkingPaymentType(for: .eftpos), .eftpos)
        XCTAssertEqual(parkingPaymentType(for: .cardsDiners), .cardsDiners)
        XCTAssertEqual(parkingPaymentType(for: .cardsGeldkarte), .cardsGeldkarte)
        XCTAssertEqual(parkingPaymentType(for: .cardsDiscover), .cardsDiscover)
        XCTAssertEqual(parkingPaymentType(for: .cheque), .cheque)
        XCTAssertEqual(parkingPaymentType(for: .cardsEcash), .cardsEcash)
        XCTAssertEqual(parkingPaymentType(for: .cardsJcb), .cardsJcb)
        XCTAssertEqual(parkingPaymentType(for: .cardsOperatorcard), .cardsOperatorcard)
        XCTAssertEqual(parkingPaymentType(for: .cardsSmartcard), .cardsSmartcard)
        XCTAssertEqual(parkingPaymentType(for: .cardsTelepeage), .cardsTelepeage)
        XCTAssertEqual(parkingPaymentType(for: .cardsTotalgr), .cardsTotalgr)
        XCTAssertEqual(parkingPaymentType(for: .cardsMoneo), .cardsMoneo)
        XCTAssertEqual(parkingPaymentType(for: .cardsFlashpay), .cardsFlashpay)
        XCTAssertEqual(parkingPaymentType(for: .cardsCashcard), .cardsCashcard)
        XCTAssertEqual(parkingPaymentType(for: .cardsVcashcard), .cardsVcashcard)
        XCTAssertEqual(parkingPaymentType(for: .cardsCepas), .cardsCepas)
        XCTAssertEqual(parkingPaymentType(for: .cardsOctopus), .cardsOctopus)
        XCTAssertEqual(parkingPaymentType(for: .alipay), .alipay)
        XCTAssertEqual(parkingPaymentType(for: .wechatpay), .wechatpay)
        XCTAssertEqual(parkingPaymentType(for: .cardsEasycard), .cardsEasycard)
        XCTAssertEqual(parkingPaymentType(for: .cardsCartebleue), .cardsCartebleue)
        XCTAssertEqual(parkingPaymentType(for: .cardsTouchngo), .cardsTouchngo)
    }

    private func parkingPaymentType(for coreType: CoreParkingPaymentType) -> ParkingPaymentType {
        NSNumber(value: coreType.rawValue).parkingPaymentType
    }
}
