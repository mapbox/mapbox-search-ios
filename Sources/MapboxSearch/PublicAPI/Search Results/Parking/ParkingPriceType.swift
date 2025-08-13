/// Type of parking pricing.
@_spi(Experimental)
public struct ParkingPriceType: Codable, Hashable, Sendable {
    public static let duration: ParkingPriceType = .init(rawValue: 0)
    public static let durationAdditional: ParkingPriceType = .init(rawValue: 1)
    public static let custom: ParkingPriceType = .init(rawValue: 2)

    let rawValue: Int
}

extension NSNumber {
    var parkingPriceType: ParkingPriceType {
        ParkingPriceType(rawValue: intValue)
    }
}
