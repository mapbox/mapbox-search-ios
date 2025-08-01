/// Rate information for parking facilities.
@_spi(Experimental)
public struct ParkingRateInfo: Codable, Hashable, Sendable {
    public let currencySymbol: String?
    public let currencyCode: String?
    public let rates: [ParkingRate]

    public init(
        currencySymbol: String?,
        currencyCode: String?,
        rates: [ParkingRate]
    ) {
        self.currencySymbol = currencySymbol
        self.currencyCode = currencyCode
        self.rates = rates
    }
}

extension CoreParkingRateInfo {
    var parkingRateInfo: ParkingRateInfo {
        ParkingRateInfo(
            currencySymbol: currencySymbol,
            currencyCode: currencyCode,
            rates: rates?.map(\.parkingRate) ?? []
        )
    }
}
