import Foundation
@testable import MapboxSearch

extension [CoreOpenPeriod] {
    /// Stub schedule:
    ///     Monday – Friday:    8:35 – 20:18
    ///     Saturday, Sunday:  10:00 – 19:00
    static func coreOpenHourPeriods() -> [CoreOpenPeriod] {
        let mondayPeriod = CoreOpenPeriod(openD: 0, openH: 8, openM: 35, closedD: 0, closedH: 20, closedM: 18)
        let tuesdayPeriod = CoreOpenPeriod(openD: 1, openH: 8, openM: 35, closedD: 1, closedH: 20, closedM: 18)
        let wednesdayPeriod = CoreOpenPeriod(openD: 2, openH: 8, openM: 35, closedD: 2, closedH: 20, closedM: 18)
        let thursdayPeriod = CoreOpenPeriod(openD: 3, openH: 8, openM: 35, closedD: 3, closedH: 20, closedM: 18)
        let fridayPeriod = CoreOpenPeriod(openD: 4, openH: 8, openM: 35, closedD: 4, closedH: 20, closedM: 18)
        let saturdayPeriod = CoreOpenPeriod(openD: 5, openH: 10, openM: 00, closedD: 5, closedH: 19, closedM: 00)
        let sundayPeriod = CoreOpenPeriod(openD: 6, openH: 10, openM: 00, closedD: 6, closedH: 19, closedM: 00)

        return [
            mondayPeriod,
            tuesdayPeriod,
            wednesdayPeriod,
            thursdayPeriod,
            fridayPeriod,
            saturdayPeriod,
            sundayPeriod,
        ]
    }
}

extension [OpenPeriod] {
    static func fullWeekPeriodsSample() -> [OpenPeriod] {
        [CoreOpenPeriod].coreOpenHourPeriods().map(OpenPeriod.init)
    }
}
