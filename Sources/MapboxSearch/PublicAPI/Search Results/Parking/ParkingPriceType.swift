@_spi(Experimental)
public struct ParkingPriceType: Codable, Hashable {
    public static let unknown: ParkingPriceType = .init(rawValue: 0)
    public static let duration: ParkingPriceType = .init(rawValue: 1)
    public static let durationAdditional: ParkingPriceType = .init(rawValue: 2)
    public static let custom: ParkingPriceType = .init(rawValue: 3)

    let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension NSNumber {
    var parkingPriceType: ParkingPriceType {
        ParkingPriceType(rawValue: intValue)
    }
}
