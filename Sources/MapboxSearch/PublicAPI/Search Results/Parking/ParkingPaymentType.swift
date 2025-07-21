/// Payment types for parking.
@_spi(Experimental)
public struct ParkingPaymentType: Codable, Hashable {
    public static let unknown: ParkingPaymentType = .init(rawValue: 0)
    public static let coins: ParkingPaymentType = .init(rawValue: 1)
    public static let notes: ParkingPaymentType = .init(rawValue: 2)
    public static let contactless: ParkingPaymentType = .init(rawValue: 3)
    public static let cards: ParkingPaymentType = .init(rawValue: 4)
    public static let mobile: ParkingPaymentType = .init(rawValue: 5)
    public static let cardsVisa: ParkingPaymentType = .init(rawValue: 6)
    public static let cardsMastercard: ParkingPaymentType = .init(rawValue: 7)
    public static let cardsAmex: ParkingPaymentType = .init(rawValue: 8)
    public static let cardsMaestro: ParkingPaymentType = .init(rawValue: 9)
    public static let eftpos: ParkingPaymentType = .init(rawValue: 10)
    public static let cardsDiners: ParkingPaymentType = .init(rawValue: 11)
    public static let cardsGeldkarte: ParkingPaymentType = .init(rawValue: 12)
    public static let cardsDiscover: ParkingPaymentType = .init(rawValue: 13)
    public static let cheque: ParkingPaymentType = .init(rawValue: 14)
    public static let cardsEcash: ParkingPaymentType = .init(rawValue: 15)
    public static let cardsJcb: ParkingPaymentType = .init(rawValue: 16)
    public static let cardsOperatorcard: ParkingPaymentType = .init(rawValue: 17)
    public static let cardsSmartcard: ParkingPaymentType = .init(rawValue: 18)
    public static let cardsTelepeage: ParkingPaymentType = .init(rawValue: 19)
    public static let cardsTotalgr: ParkingPaymentType = .init(rawValue: 20)
    public static let cardsMoneo: ParkingPaymentType = .init(rawValue: 21)
    public static let cardsFlashpay: ParkingPaymentType = .init(rawValue: 22)
    public static let cardsCashcard: ParkingPaymentType = .init(rawValue: 23)
    public static let cardsVcashcard: ParkingPaymentType = .init(rawValue: 24)
    public static let cardsCepas: ParkingPaymentType = .init(rawValue: 25)
    public static let cardsOctopus: ParkingPaymentType = .init(rawValue: 26)
    public static let alipay: ParkingPaymentType = .init(rawValue: 27)
    public static let wechatpay: ParkingPaymentType = .init(rawValue: 28)
    public static let cardsEasycard: ParkingPaymentType = .init(rawValue: 29)
    public static let cardsCartebleue: ParkingPaymentType = .init(rawValue: 30)
    public static let cardsTouchngo: ParkingPaymentType = .init(rawValue: 31)

    let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension NSNumber {
    var parkingPaymentType: ParkingPaymentType {
        ParkingPaymentType(rawValue: intValue)
    }
}
