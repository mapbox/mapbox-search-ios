@_spi(Experimental) @testable import MapboxSearch
import XCTest

class ParkingInfoTests: XCTestCase {
    @available(iOS 15.0, *)
    func testCoreToPublicMapping() {
        let coreParkingInfo = CoreParkingInfo(
            capacity: 10,
            rateInfo: CoreParkingRateInfo(
                currencySymbol: "$",
                currencyCode: "USD",
                rates: [
                    .init(maxStay: "PT6M",
                          times: [
                            .init(days: [0],
                                  fromHour: 6,
                                  fromMinute: 0,
                                  toHour: 20,
                                  toMinute: 0
                                 )
                          ],
                          prices: [
                            .init(
                                type: 3,
                                amount: 5,
                                value: CoreParkingRateValue
                                    .fromParkingRateCustomValue(.evening)
                            )
                          ])
                ]),
            availability: 5,
            availabilityLevel: 2,
            availabilityAt: Date().ISO8601Format(),
            trend: 2,
            paymentMethods: [2,3,4,5],
            paymentTypes: [2,3],
            restrictions: [4,5]
        )
        let parkingInfo = coreParkingInfo.parkingInfo
        XCTAssertEqual(coreParkingInfo.capacity?.intValue, parkingInfo.capacity)
        XCTAssertEqual(coreParkingInfo.rateInfo?.currencySymbol, parkingInfo.rateInfo?.currencySymbol)
        XCTAssertEqual(coreParkingInfo.rateInfo?.currencyCode, parkingInfo.rateInfo?.currencyCode)


        let firstCoreRate = coreParkingInfo.rateInfo!.rates!.first!
        let firstRate = parkingInfo.rateInfo!.rates.first!

        XCTAssertEqual(
            firstCoreRate.maxStay,
            firstRate.maxStayISO8601
        )

        XCTAssertEqual(
            firstCoreRate.times?.first!.days?.first!.intValue,
            firstRate.times.first!.days.first!
        )

        XCTAssertEqual(
            firstCoreRate.times?.first!.days?.first!.intValue,
            firstRate.times.first!.days.first!
        )

        XCTAssertEqual(
            firstCoreRate.prices?.first!.type?.intValue,
            firstRate.prices.first!.type.rawValue
        )

        XCTAssertEqual(
            ParkingRateValue.customValue(.earlyBird),
            parkingInfo.rateInfo?.rates.first!.prices.first!.value
        )

        XCTAssertEqual(coreParkingInfo.availability?.intValue, parkingInfo.availability)
        XCTAssertEqual(coreParkingInfo.availabilityLevel?.intValue, parkingInfo.availabilityLevel.rawValue)
        XCTAssertEqual(coreParkingInfo.trend?.intValue, parkingInfo.trend.rawValue)
        XCTAssertEqual(coreParkingInfo.paymentMethods?.last!.intValue, parkingInfo.paymentMethods.last!.rawValue)
        XCTAssertEqual(coreParkingInfo.paymentTypes?.last!.intValue, parkingInfo.paymentTypes.last!.rawValue)
        XCTAssertEqual(coreParkingInfo.restrictions?.last!.intValue, parkingInfo.restrictions.last!.rawValue)
    }
}
