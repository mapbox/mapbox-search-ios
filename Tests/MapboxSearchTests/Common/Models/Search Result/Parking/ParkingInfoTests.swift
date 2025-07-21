@_spi(Experimental) @testable import MapboxSearch
import XCTest

final class ParkingInfoTests: XCTestCase {
    func testCoreToPublicMapping() {
        let date = "date_string"
        let coreCoreParkingRateTime1 = CoreParkingRateTime(
            days: [0, 1],
            fromHour: 6,
            fromMinute: 0,
            toHour: 20,
            toMinute: 0
        )
        let coreCoreParkingRateTime2 = CoreParkingRateTime(
            days: [2, 3, 4, 5],
            fromHour: 5,
            fromMinute: 30,
            toHour: 21,
            toMinute: 30
        )
        let coreParkingRatePrice = CoreParkingRatePrice(
            type: NSNumber(value: CoreParkingPriceType.custom.rawValue),
            amount: 500,
            value: CoreParkingRateValue.fromParkingRateCustomValue(.evening)
        )
        let coreParkingRate = CoreParkingRate(
            maxStay: "PT6M",
            times: [coreCoreParkingRateTime1, coreCoreParkingRateTime2],
            prices: [coreParkingRatePrice]
        )

        let paymentMethods: [CoreParkingPaymentMethod] = [.payOnFoot, .attendant]
        let paymentTypes: [CoreParkingPaymentType] = [.cards, .cardsAmex]
        let paymentRestrictions: [CoreParkingRestriction] = [.bookingOnly, .customers, .monthlyOnly]
        let coreParkingInfo = CoreParkingInfo(
            capacity: 10,
            rateInfo: CoreParkingRateInfo(
                currencySymbol: "$",
                currencyCode: "USD",
                rates: [coreParkingRate]
            ),
            availability: 5,
            availabilityLevel: NSNumber(value: CoreParkingAvailabilityLevel.mid.rawValue),
            availabilityAt: date,
            trend: NSNumber(value: CoreParkingTrend.increasing.rawValue),
            paymentMethods: paymentMethods.map { NSNumber(value: $0.rawValue) },
            paymentTypes: paymentTypes.map { NSNumber(value: $0.rawValue) },
            restrictions: paymentRestrictions.map { NSNumber(value: $0.rawValue) }
        )

        let time1 = ParkingRateTime(days: [0, 1], fromHour: 6, fromMinute: 0, toHour: 20, toMinute: 0)
        let time2 = ParkingRateTime(days: [2, 3, 4, 5], fromHour: 5, fromMinute: 30, toHour: 21, toMinute: 30)
        let price = ParkingRatePrice(type: .custom, amount: 500, value: .customValue(.evening))
        let rate = ParkingRate(maxStayISO8601: "PT6M", times: [time1, time2], prices: [price])
        let expectedParkingInfo = ParkingInfo(
            capacity: 10,
            rateInfo: ParkingRateInfo(currencySymbol: "$", currencyCode: "USD", rates: [rate]),
            availability: 5,
            availabilityLevel: .mid,
            availabilityUpdatedAt: date,
            trend: .increasing,
            paymentMethods: [.payOnFoot, .attendant],
            paymentTypes: [.cards, .cardsAmex],
            restrictions: [.bookingOnly, .customers, .monthlyOnly]
        )

        XCTAssertEqual(coreParkingInfo.parkingInfo, expectedParkingInfo)
    }
}
