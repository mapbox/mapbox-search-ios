import Foundation

/// Single entry of shopping hours for POI entry
public struct OpenPeriod: Codable, Hashable {
    /// Represents the start of the period. Components should contain weekday, hour and minute
    public let start: DateComponents
    /// Represents the end of the period. Components should contain weekday, hour and minute
    public let end: DateComponents
    
    init(_ core: CoreOpenPeriod) {
        start = DateComponents(calendar: Calendar(identifier: .gregorian),
                               hour: Int(core.openH),
                               minute: Int(core.openM),
                               weekday: (Int(core.openD) + 1) % 7 + 1) // Convert Monday=0 style to the Sunday=1, Monday=2 iOS default style
        end = DateComponents(calendar: Calendar(identifier: .gregorian),
                               hour: Int(core.closedH),
                               minute: Int(core.closedM),
                               weekday: (Int(core.closedD) + 1) % 7 + 1)
    }
}
