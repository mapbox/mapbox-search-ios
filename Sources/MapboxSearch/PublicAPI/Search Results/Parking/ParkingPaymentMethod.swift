/// Payment methods for parking.
@_spi(Experimental)
public struct ParkingPaymentMethod: Codable, Hashable, Sendable {
    public static let unknown: ParkingPaymentMethod = .init(rawValue: 0)
    public static let payOnFoot: ParkingPaymentMethod = .init(rawValue: 1)
    public static let payAndDisplay: ParkingPaymentMethod = .init(rawValue: 2)
    public static let payOnExit: ParkingPaymentMethod = .init(rawValue: 3)
    public static let payOnEntry: ParkingPaymentMethod = .init(rawValue: 4)
    public static let parkingMeter: ParkingPaymentMethod = .init(rawValue: 5)
    public static let multiSpaceMeter: ParkingPaymentMethod = .init(rawValue: 6)
    public static let honestyBox: ParkingPaymentMethod = .init(rawValue: 7)
    public static let attendant: ParkingPaymentMethod = .init(rawValue: 8)
    public static let payByPlate: ParkingPaymentMethod = .init(rawValue: 9)
    public static let payAtReception: ParkingPaymentMethod = .init(rawValue: 10)
    public static let payByPhone: ParkingPaymentMethod = .init(rawValue: 11)
    public static let payByCoupon: ParkingPaymentMethod = .init(rawValue: 12)
    public static let electronicParkingSystem: ParkingPaymentMethod = .init(rawValue: 13)

    let rawValue: Int
}

extension NSNumber {
    var parkingPaymentMethod: ParkingPaymentMethod {
        ParkingPaymentMethod(rawValue: intValue)
    }
}
