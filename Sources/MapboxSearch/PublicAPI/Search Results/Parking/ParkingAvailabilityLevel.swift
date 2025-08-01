/// Availability level for parking facilities.
@_spi(Experimental)
public struct ParkingAvailabilityLevel: Codable, Hashable, Sendable {
    public static let unknown: ParkingAvailabilityLevel = .init(rawValue: 0)
    public static let low: ParkingAvailabilityLevel = .init(rawValue: 1)
    public static let mid: ParkingAvailabilityLevel = .init(rawValue: 2)
    public static let high: ParkingAvailabilityLevel = .init(rawValue: 3)

    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension NSNumber {
    var parkingAvailabilityLevel: ParkingAvailabilityLevel {
        ParkingAvailabilityLevel(rawValue: intValue)
    }
}
