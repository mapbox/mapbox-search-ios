// Copyright © 2021 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

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
}
