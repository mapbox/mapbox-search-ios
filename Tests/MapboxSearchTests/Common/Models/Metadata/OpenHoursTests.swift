@testable import MapboxSearch
import XCTest

class OpenHoursTests: XCTestCase {
    func testAlwaysOpenedCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .alwaysOpen, periods: [], weekdayText: nil, note: nil)
        let hours = OpenHours(coreHours)

        XCTAssertEqual(hours, .alwaysOpened)
    }

    func testTemporarilyClosedCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .temporarilyClosed, periods: [], weekdayText: nil, note: nil)
        let hours = OpenHours(coreHours)

        XCTAssertEqual(hours, .temporarilyClosed)
    }

    func testPermanentlyClosedCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .permanentlyClosed, periods: [], weekdayText: nil, note: nil)
        let hours = OpenHours(coreHours)

        XCTAssertEqual(hours, .permanentlyClosed)
    }

    func testScheduledCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .scheduled, periods: .coreOpenHourPeriods(), weekdayText: nil, note: nil)
        let hours = OpenHours(coreHours)

        if case .scheduled(let periods, _, _) = hours {
            XCTAssertEqual(periods.count, 7)
        } else {
            XCTFail("Expected `.scheduled` case")
        }
    }

    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()

    func testSimpleCaseCodableSupport() throws {
        let data = try jsonEncoder.encode(OpenHours.permanentlyClosed)
        let hours = try jsonDecoder.decode(OpenHours.self, from: data)

        XCTAssertEqual(hours, .permanentlyClosed)
    }

    /// Test Scheduled Case returned from SBS API
    func testScheduledCaseSBSCodableSupport() throws {
        let scheduled = OpenHours.scheduled(periods: .fullWeekPeriodsSample())

        let data = try jsonEncoder.encode(scheduled)
        let decodedScheduled = try jsonDecoder.decode(OpenHours.self, from: data)

        XCTAssertEqual(decodedScheduled, scheduled)
        if case .scheduled(let periods, _, _) = decodedScheduled {
            XCTAssertEqual(periods, .fullWeekPeriodsSample())
        } else {
            XCTFail("Expected `.scheduled` case")
        }
    }

    /// Test Scheduled Case returned from SearchBox API
    func testScheduledCaseSearchBoxCodableSupport() throws {
        let scheduled = OpenHours.scheduled(
            periods: .fullWeekPeriodsSample(),
            weekdayText: .fullWeekdayTextSample(),
            note: "Value present"
        )

        let data = try jsonEncoder.encode(scheduled)
        let decodedScheduled = try jsonDecoder.decode(OpenHours.self, from: data)

        XCTAssertEqual(decodedScheduled, scheduled)
        if case .scheduled(let periods, let weekdayText, let note) = decodedScheduled {
            XCTAssertEqual(periods, .fullWeekPeriodsSample())
            XCTAssertEqual(weekdayText, .fullWeekdayTextSample())
            XCTAssertEqual("Value present", note)
        } else {
            XCTFail("Expected `.scheduled` case")
        }
    }
}

extension OpenHours.WeekdayText {
    public static func fullWeekdayTextSample() -> Self {
        [
            "Monday 08:35am - 8:18pm",
            "Monday 08:35am - 8:18pm",
            "Monday 08:35am - 8:18pm",
            "Monday 08:35am - 8:18pm",
            "Monday 08:35am - 8:18pm",
            "Saturday 10:00am - 7:00pm",
            "Sunday 10:00am - 7:00pm",
        ]
    }
}
