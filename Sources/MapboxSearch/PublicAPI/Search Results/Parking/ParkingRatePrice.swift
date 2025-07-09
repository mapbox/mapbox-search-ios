@_spi(Experimental)
public struct ParkingRatePrice: Codable, Hashable {
    public let type: ParkingPriceType
    public let amount: Decimal
    public let value: ParkingRateValue

    public init(type: ParkingPriceType, amount: Decimal, value: ParkingRateValue) {
        self.type = type
        self.amount = amount
        self.value = value
    }
}

extension CoreParkingRatePrice {
    var parkingRatePrice: ParkingRatePrice {
        ParkingRatePrice(
            type: type?.parkingPriceType ?? .unknown,
            amount: amount?.decimalValue ?? 0,
            value: value?.parkingRateValue ?? .unknown
        )
    }
}
