/// Trend of parking availability changes.
@_spi(Experimental)
public struct ParkingTrend: Codable, Hashable {
    public static let unknown: ParkingTrend = .init(rawValue: 0)
    public static let noChange: ParkingTrend = .init(rawValue: 1)
    public static let decreasing: ParkingTrend = .init(rawValue: 2)
    public static let increasing: ParkingTrend = .init(rawValue: 3)

    let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension NSNumber {
    var parkingTrend: ParkingTrend {
        ParkingTrend(rawValue: intValue)
    }
}
