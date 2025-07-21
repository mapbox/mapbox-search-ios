/// Time period for parking rates.
@_spi(Experimental)
public struct ParkingRateTime: Codable, Hashable {
    public typealias WeekDay = Int

    public let days: [WeekDay]
    public let fromHour: Int
    public let fromMinute: Int
    public let toHour: Int
    public let toMinute: Int

    public init(days: [WeekDay], fromHour: Int, fromMinute: Int, toHour: Int, toMinute: Int) {
        self.days = days
        self.fromHour = fromHour
        self.fromMinute = fromMinute
        self.toHour = toHour
        self.toMinute = toMinute
    }
}

extension CoreParkingRateTime {
    var parkingRateTime: ParkingRateTime {
        .init(
            days: days?.map(\.intValue) ?? [],
            fromHour: fromHour?.intValue ?? 0,
            fromMinute: fromMinute?.intValue ?? 0,
            toHour: toHour?.intValue ?? 0,
            toMinute: toMinute?.intValue ?? 0
        )
    }
}
