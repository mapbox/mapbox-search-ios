@_spi(Experimental)
public struct ParkingRestriction: Codable, Hashable {
    /** Unknown or unspecified parking restriction. */
    public static let unknown: ParkingRestriction = .init(rawValue: 0)
    /** Parking restricted to electric vehicles only. */
    public static let evOnly: ParkingRestriction = .init(rawValue: 1)
    /** Parking restricted to plugged-in electric vehicles only. */
    public static let plugged: ParkingRestriction = .init(rawValue: 2)
    /** Parking restricted to vehicles with disabled permits only. */
    public static let disabled: ParkingRestriction = .init(rawValue: 3)
    /** Parking restricted to customers only. */
    public static let customers: ParkingRestriction = .init(rawValue: 4)
    /** Parking restricted to motorcycles only. */
    public static let motorCycles: ParkingRestriction = .init(rawValue: 5)
    /** No parking allowed at this location. */
    public static let noParking: ParkingRestriction = .init(rawValue: 6)
    /** Maximum stay time restriction applies. */
    public static let maxStay: ParkingRestriction = .init(rawValue: 7)
    /** Parking restricted to monthly permit holders only. */
    public static let monthlyOnly: ParkingRestriction = .init(rawValue: 8)
    /** Parking restricted - no SUVs allowed. */
    public static let noSuv: ParkingRestriction = .init(rawValue: 9)
    /** Parking restricted - no LPG vehicles allowed. */
    public static let noLpg: ParkingRestriction = .init(rawValue: 10)
    /** Parking restricted to valet service only. */
    public static let valetOnly: ParkingRestriction = .init(rawValue: 11)
    /** Parking restricted to visitors only. */
    public static let visitorsOnly: ParkingRestriction = .init(rawValue: 12)
    /** Parking restricted to event attendees only. */
    public static let eventsOnly: ParkingRestriction = .init(rawValue: 13)
    /** No restrictions apply outside of specified hours. */
    public static let noRestrictionsOutsideHours: ParkingRestriction = .init(rawValue: 14)
    /** Parking requires advance booking. */
    public static let bookingOnly: ParkingRestriction = .init(rawValue: 15)
    /** Parking disk required for time-limited parking. */
    public static let parkingDisk: ParkingRestriction = .init(rawValue: 16)

    let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension NSNumber {
    var parkingResticution: ParkingRestriction {
        ParkingRestriction(rawValue: intValue)
    }
}
