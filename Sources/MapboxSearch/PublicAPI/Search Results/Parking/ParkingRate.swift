@_spi(Experimental)
public struct ParkingRate: Codable, Hashable {
    public let maxStayISO8601: String?
    public let times: [ParkingRateTime]
    public let prices: [ParkingRatePrice]

    public init(maxStayISO8601: String?,
         times: [ParkingRateTime],
         prices: [ParkingRatePrice]) {
        self.maxStayISO8601 = maxStayISO8601
        self.times = times
        self.prices = prices
    }
}

extension CoreParkingRate {
    var parkingRate: ParkingRate {
        ParkingRate(
            maxStayISO8601: maxStay,
            times: times?.map(\.parkingRateTime) ?? [],
            prices: prices?.map(\.parkingRatePrice) ?? []
        )
    }
}
