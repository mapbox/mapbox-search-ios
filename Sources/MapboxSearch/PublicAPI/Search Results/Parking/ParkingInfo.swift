/// Parking information for POIs that represent parking facilities (e.g., parking lots, garages, street parking etc.).
@_spi(Experimental)
public struct ParkingInfo: Codable, Hashable, Sendable {
    public let capacity: Int?
    public let rateInfo: ParkingRateInfo?
    public let availability: Int?
    public let availabilityLevel: ParkingAvailabilityLevel
    public let availabilityAt: String?
    public let trend: ParkingTrend
    public let paymentMethods: [ParkingPaymentMethod]
    public let paymentTypes: [ParkingPaymentType]
    public let restrictions: [ParkingRestriction]

    public init(
        capacity: Int?,
        rateInfo: ParkingRateInfo?,
        availability: Int?,
        availabilityLevel: ParkingAvailabilityLevel,
        availabilityAt: String?,
        trend: ParkingTrend,
        paymentMethods: [ParkingPaymentMethod],
        paymentTypes: [ParkingPaymentType],
        restrictions: [ParkingRestriction]
    ) {
        self.capacity = capacity
        self.rateInfo = rateInfo
        self.availability = availability
        self.availabilityLevel = availabilityLevel
        self.availabilityAt = availabilityAt
        self.trend = trend
        self.paymentMethods = paymentMethods
        self.paymentTypes = paymentTypes
        self.restrictions = restrictions
    }
}

extension CoreParkingInfo {
    var parkingInfo: ParkingInfo {
        ParkingInfo(
            capacity: capacity?.intValue,
            rateInfo: rateInfo?.parkingRateInfo,
            availability: availability?.intValue,
            availabilityLevel: availabilityLevel?.parkingAvailabilityLevel ?? .unknown,
            availabilityAt: availabilityAt,
            trend: trend?.parkingTrend ?? .unknown,
            paymentMethods: paymentMethods?.map(\.parkingPaymentMethod) ?? [],
            paymentTypes: paymentTypes?.map(\.parkingPaymentType) ?? [],
            restrictions: restrictions?.map(\.parkingResticution) ?? []
        )
    }
}
