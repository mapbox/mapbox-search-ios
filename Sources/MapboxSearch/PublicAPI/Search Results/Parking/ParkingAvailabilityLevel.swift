@_spi(Experimental)
public struct ParkingAvailabilityLevel: Codable, Hashable {
    public static let unknown: ParkingAvailabilityLevel = .init(rawValue: 0)
    public static let low: ParkingAvailabilityLevel = .init(rawValue: 1)
    public static let mid: ParkingAvailabilityLevel = .init(rawValue: 2)
    public static let high: ParkingAvailabilityLevel = .init(rawValue: 3)

    let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension NSNumber {
    var parkingAvailabilityLevel: ParkingAvailabilityLevel {
        ParkingAvailabilityLevel(rawValue: intValue)
    }
}
