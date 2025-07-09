public enum SearchResultParkingRestriction {
    /** Unknown or unspecified parking restriction. */
    case unknown
    /** Parking restricted to electric vehicles only. */
    case evOnly
    /** Parking restricted to plugged-in electric vehicles only. */
    case plugged
    /** Parking restricted to vehicles with disabled permits only. */
    case disabled
    /** Parking restricted to customers only. */
    case customers
    /** Parking restricted to motorcycles only. */
    case motorCycles
    /** No parking allowed at this location. */
    case noParking
    /** Maximum stay time restriction applies. */
    case maxStay
    /** Parking restricted to monthly permit holders only. */
    case monthlyOnly
    /** Parking restricted - no SUVs allowed. */
    case noSuv
    /** Parking restricted - no LPG vehicles allowed. */
    case noLpg
    /** Parking restricted to valet service only. */
    case valetOnly
    /** Parking restricted to visitors only. */
    case visitorsOnly
    /** Parking restricted to event attendees only. */
    case eventsOnly
    /** No restrictions apply outside of specified hours. */
    case noRestrictionsOutsideHours
    /** Parking requires advance booking. */
    case bookingOnly
    /** Parking disk required for time-limited parking. */
    case parkingDisk
}
