@testable import MapboxSearch
import XCTest

class OpenPeriodTests: XCTestCase {
    func testMondayPeriodEncoding() throws {
        let mondayPeriod = CoreOpenPeriod(openD: 0, openH: 8, openM: 35, closedD: 0, closedH: 20, closedM: 18)
        let period = OpenPeriod(mondayPeriod)

        XCTAssertEqual(period.start.weekday, 2)
        XCTAssertEqual(period.end.weekday, period.start.weekday)

        XCTAssertEqual(period.start.hour, 8)
        XCTAssertEqual(period.end.hour, 20)

        XCTAssertEqual(period.start.minute, 35)
        XCTAssertEqual(period.end.minute, 18)
    }

    func testDateConversionInGregorianCalendar() throws {
        let sundayPeriod = CoreOpenPeriod(openD: 6, openH: 10, openM: 00, closedD: 6, closedH: 19, closedM: 00)
        let period = OpenPeriod(sundayPeriod)

        let calendar = Calendar(identifier: .gregorian)

        var startDateComponents = period.start
        startDateComponents.year = 2021
        startDateComponents.weekdayOrdinal = 1
        startDateComponents.timeZone = TimeZone(secondsFromGMT: 0)

        let startDate = try XCTUnwrap(calendar.date(from: startDateComponents))

        let startDateString = ISO8601DateFormatter().string(from: startDate)
        XCTAssertEqual(startDateString, "2021-01-03T10:00:00Z") // Sunday
    }

    func test24CloseHourInGregorianCalendar() throws {
        let sundayPeriod = CoreOpenPeriod(openD: 6, openH: 10, openM: 00, closedD: 6, closedH: 24, closedM: 00)
        let period = OpenPeriod(sundayPeriod)

        let calendar = Calendar(identifier: .gregorian)

        var endDateComponents = period.end
        endDateComponents.year = 2021
        endDateComponents.weekdayOrdinal = 1
        endDateComponents.timeZone = TimeZone(secondsFromGMT: 0)

        let endDate = try XCTUnwrap(calendar.date(from: endDateComponents))

        let endDateString = ISO8601DateFormatter().string(from: endDate)
        XCTAssertEqual(endDateString, "2021-01-04T00:00:00Z") // Monday
    }

    func testWeekdayConversionInGregorianCalenda() {
        let sundayPeriod = CoreOpenPeriod(openD: 6, openH: 10, openM: 10, closedD: 6, closedH: 22, closedM: 00)
        let sundayOpenPeriod = OpenPeriod(sundayPeriod)
        XCTAssertEqual(sundayOpenPeriod.start.weekday, 1)
        XCTAssertEqual(sundayOpenPeriod.end.weekday, 1)

        let mondayPeriod = CoreOpenPeriod(openD: 0, openH: 10, openM: 10, closedD: 0, closedH: 22, closedM: 00)
        let mondayOpenPeriod = OpenPeriod(mondayPeriod)
        XCTAssertEqual(mondayOpenPeriod.start.weekday, 2)
        XCTAssertEqual(mondayOpenPeriod.end.weekday, 2)

        let tuesdayPeriod = CoreOpenPeriod(openD: 1, openH: 10, openM: 10, closedD: 1, closedH: 22, closedM: 00)
        let tuesdayOpenPeriod = OpenPeriod(tuesdayPeriod)
        XCTAssertEqual(tuesdayOpenPeriod.start.weekday, 3)
        XCTAssertEqual(tuesdayOpenPeriod.end.weekday, 3)

        let wednesdayPeriod = CoreOpenPeriod(openD: 2, openH: 10, openM: 10, closedD: 2, closedH: 22, closedM: 00)
        let wednesdayOpenPeriod = OpenPeriod(wednesdayPeriod)
        XCTAssertEqual(wednesdayOpenPeriod.start.weekday, 4)
        XCTAssertEqual(wednesdayOpenPeriod.end.weekday, 4)

        let thursdayPeriod = CoreOpenPeriod(openD: 3, openH: 10, openM: 10, closedD: 3, closedH: 22, closedM: 00)
        let thursdayOpenPeriod = OpenPeriod(thursdayPeriod)
        XCTAssertEqual(thursdayOpenPeriod.start.weekday, 5)
        XCTAssertEqual(thursdayOpenPeriod.end.weekday, 5)

        let fridayPeriod = CoreOpenPeriod(openD: 4, openH: 10, openM: 10, closedD: 4, closedH: 22, closedM: 00)
        let fridayOpenPeriod = OpenPeriod(fridayPeriod)
        XCTAssertEqual(fridayOpenPeriod.start.weekday, 6)
        XCTAssertEqual(fridayOpenPeriod.end.weekday, 6)

        let saturdayPeriod = CoreOpenPeriod(openD: 5, openH: 10, openM: 10, closedD: 5, closedH: 22, closedM: 00)
        let saturdayOpenPeriod = OpenPeriod(saturdayPeriod)
        XCTAssertEqual(saturdayOpenPeriod.start.weekday, 7)
        XCTAssertEqual(saturdayOpenPeriod.end.weekday, 7)
    }
}
