/// Custom parking rate values.
@_spi(Experimental)
public struct ParkingRateCustomValue: Codable, Hashable, Sendable {
    /// 6 months Monday to Friday.
    public static let sixMonthsMonFri: ParkingRateCustomValue = .init(rawValue: 0)
    /// Bank holiday rates.
    public static let bankHoliday: ParkingRateCustomValue = .init(rawValue: 1)
    /// Daytime rates.
    public static let daytime: ParkingRateCustomValue = .init(rawValue: 2)
    /// Early bird rates.
    public static let earlyBird: ParkingRateCustomValue = .init(rawValue: 3)
    /// Evening rates.
    public static let evening: ParkingRateCustomValue = .init(rawValue: 4)
    /// Flat rate pricing.
    public static let flatRate: ParkingRateCustomValue = .init(rawValue: 5)
    /// Maximum rate.
    public static let max: ParkingRateCustomValue = .init(rawValue: 6)
    /// Maximum rate applied only once.
    public static let maxOnlyOnce: ParkingRateCustomValue = .init(rawValue: 7)
    /// Minimum rate.
    public static let minimum: ParkingRateCustomValue = .init(rawValue: 8)
    /// Monthly rate.
    public static let month: ParkingRateCustomValue = .init(rawValue: 9)
    /// Monthly rate Monday to Friday.
    public static let monthMonFri: ParkingRateCustomValue = .init(rawValue: 10)
    /// Monthly reserved rate.
    public static let monthReserved: ParkingRateCustomValue = .init(rawValue: 11)
    /// Monthly unreserved rate.
    public static let monthUnreserved: ParkingRateCustomValue = .init(rawValue: 12)
    /// Overnight rate.
    public static let overnight: ParkingRateCustomValue = .init(rawValue: 13)
    /// Quarterly rate Monday to Friday.
    public static let quarterMonFri: ParkingRateCustomValue = .init(rawValue: 14)
    /// Rate until closing.
    public static let untilClosing: ParkingRateCustomValue = .init(rawValue: 15)
    /// Weekend rate.
    public static let weekend: ParkingRateCustomValue = .init(rawValue: 16)
    /// Yearly rate Monday to Friday.
    public static let yearMonFri: ParkingRateCustomValue = .init(rawValue: 17)

    let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension CoreParkingRateCustomValue {
    var parkingRateCustomValue: ParkingRateCustomValue {
        ParkingRateCustomValue(rawValue: rawValue)
    }
}
