@testable import MapboxSearch
import XCTest

class OpenHoursTests: XCTestCase {
    func testAlwaysOpenedCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .alwaysOpen, periods: [])
        let hours = OpenHours(coreHours)

        XCTAssertEqual(hours, .alwaysOpened)
    }

    func testTemporarilyClosedCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .temporarilyClosed, periods: [])
        let hours = OpenHours(coreHours)

        XCTAssertEqual(hours, .temporarilyClosed)
    }

    func testPermanentlyClosedCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .permanentlyClosed, periods: [])
        let hours = OpenHours(coreHours)

        XCTAssertEqual(hours, .permanentlyClosed)
    }

    func testScheduledCoreConversion() throws {
        let coreHours = CoreOpenHours(mode: .scheduled, periods: .coreOpenHourPeriods())
        let hours = OpenHours(coreHours)

        if case .scheduled(let periods) = hours {
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

    func testScheduledCaseCodableSupport() throws {
        let scheduled = OpenHours.scheduled(periods: .fullWeekPeriodsSample())

        let data = try jsonEncoder.encode(scheduled)
        let decodedScheduled = try jsonDecoder.decode(OpenHours.self, from: data)

        if case .scheduled(let periods) = decodedScheduled {
            XCTAssertEqual(periods, .fullWeekPeriodsSample())
        } else {
            XCTFail("Expected `.scheduled` case")
        }
    }
}
