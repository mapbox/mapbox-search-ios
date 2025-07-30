/// Pricing information for parking rates.
@_spi(Experimental)
public struct ParkingRatePrice: Codable, Hashable, Sendable {
    /// Type of pricing, one of the values described in ``ParkingPriceType``.
    public let type: ParkingPriceType?

    /// Amount to pay.
    public let amount: Decimal?

    /// Value associated with the price - either ISO duration string or custom value.
    public let value: ParkingRateValue?

    public init(type: ParkingPriceType?, amount: Decimal?, value: ParkingRateValue?) {
        self.type = type
        self.amount = amount
        self.value = value
    }
}

extension CoreParkingRatePrice {
    var parkingRatePrice: ParkingRatePrice {
        ParkingRatePrice(
            type: type?.parkingPriceType,
            amount: amount?.decimalValue,
            value: value?.parkingRateValue
        )
    }
}
