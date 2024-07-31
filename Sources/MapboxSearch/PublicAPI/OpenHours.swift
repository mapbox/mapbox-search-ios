import Foundation

/// Opening hours structure. Related to the POI results only
public enum OpenHours: Codable, Hashable {
    /// Indicates that POI is opened 24 hours a day
    case alwaysOpened

    /// Data provider indicated that POI is temporarily closed
    case temporarilyClosed

    /// Data provider indicated that POI is permanently closed
    case permanentlyClosed

    /// The regular schedule by weekdays. Represents open periods only.
    /// Search-box results can contain additional metadata.
    case scheduled(
        periods: [OpenPeriod],
        weekdayText: WeekdayText? = nil,
        note: String? = nil
    )

    init?(_ core: CoreOpenHours) {
        switch core.mode {
        case .alwaysOpen:
            self = .alwaysOpened
        case .temporarilyClosed:
            self = .temporarilyClosed
        case .permanentlyClosed:
            self = .permanentlyClosed
        case .scheduled:
            let periods = core.periods.map(OpenPeriod.init)
            self = .scheduled(periods: periods, weekdayText: core.weekdayText, note: core.note)
        @unknown default:
            _Logger.searchSDK.warning("Cannot parse CoreOpenHours.mode (found \(core.mode.rawValue)")
            return nil
        }
    }

    enum CodingKeys: CodingKey {
        /// Mapping CoreOpenHours.mode
        case alwaysOpened, temporarilyClosed, permanentlyClosed, scheduled
        /// Mapping CoreOpenHours fields that are specific to certain modes
        case weekdayText, note
    }

    /// Initializer for custom Decoder
    /// - Parameter decoder: Decoder class
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.alwaysOpened),
           try container.decode(Bool.self, forKey: .alwaysOpened) == true
        {
            self = .alwaysOpened
        } else if container.contains(.temporarilyClosed),
                  try container.decode(Bool.self, forKey: .temporarilyClosed) == true
        {
            self = .temporarilyClosed
        } else if container.contains(.permanentlyClosed),
                  try container.decode(Bool.self, forKey: .permanentlyClosed) == true
        {
            self = .permanentlyClosed
        } else if container.contains(.scheduled) == true {
            let periods = try container.decode([OpenPeriod].self, forKey: .scheduled)
            // This type annotation
            let weekdayText: WeekdayText? = try container.decodeIfPresent(WeekdayText.self, forKey: .weekdayText)
            let note = try container.decodeIfPresent(String.self, forKey: .note)
            self = .scheduled(
                periods: periods,
                weekdayText: weekdayText,
                note: note
            )
        } else {
            var path = container.codingPath
            if let firstKey = container.allKeys.first {
                path.append(firstKey)
            }
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: path,
                    debugDescription: "Unable to decode enum."
                )
            )
        }
    }

    /// Encode structure with your own Encoder
    /// - Parameter encoder: Custom encoder entity
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .alwaysOpened:
            try container.encode(true, forKey: .alwaysOpened)
        case .temporarilyClosed:
            try container.encode(true, forKey: .temporarilyClosed)
        case .permanentlyClosed:
            try container.encode(true, forKey: .permanentlyClosed)
        case .scheduled(
            periods: let periods,
            weekdayText: let weekdayText,
            note: let note
        ):
            try container.encode(periods, forKey: .scheduled)
            try container.encodeIfPresent(weekdayText, forKey: .weekdayText)
            try container.encodeIfPresent(note, forKey: .note)
        }
    }
}

extension OpenHours {
    /// Convenience type for array of strings describing the hours a POI is regularly scheduled open.
    public typealias WeekdayText = [String]
}
