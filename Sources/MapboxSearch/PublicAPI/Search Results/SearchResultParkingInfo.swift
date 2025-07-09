public struct SearchResultParkingInfo {
    public let capacity: Int
    public let rateInfo: SearchResultParkingRateInfo
    public let availability: Int
    public let availabilityLevel: SearchResultParkingAvailabilityLevel
    public let availabilityAt: Date
    public let trend: SearchResultParkingTrend
    public let paymentMethods: [SearchResultParkingPaymentMethod]
    public let paymentTypes: [SearchResultParkingPriceType]
    public let restrictions: [SearchResultParkingRestriction]
}
