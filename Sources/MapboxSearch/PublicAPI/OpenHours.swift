import Foundation

/// Opening hours structure. Related to the POI results only
public enum OpenHours: Codable, Hashable {
    /// Indicates that POI is opened 24 hours a day
    case alwaysOpened

    /// Data provider indicated that POI is temporarily closed
    case temporarilyClosed

    /// Data provider indicated that POI is permanently closed
    case permanentlyClosed

    /// The regular schedule by weekdays. Represents open periods only
    case scheduled(periods: [OpenPeriod])

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
            self = .scheduled(periods: periods)
        @unknown default:
            _Logger.searchSDK.warning("Cannot parse CoreOpenHours.mode (got \(core.mode.rawValue)")
            return nil
        }
    }

    enum CodingKeys: CodingKey {
        case alwaysOpened, temporarilyClosed, permanentlyClosed, scheduled
    }

    /// Initializer for custom Decoder
    /// - Parameter decoder: Decoder class
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch container.allKeys.first {
        case .alwaysOpened where try container.decode(Bool.self, forKey: .alwaysOpened) == true:
            self = .alwaysOpened
        case .temporarilyClosed where try container.decode(Bool.self, forKey: .temporarilyClosed) == true:
            self = .temporarilyClosed
        case .permanentlyClosed where try container.decode(Bool.self, forKey: .permanentlyClosed) == true:
            self = .permanentlyClosed
        case .scheduled:
            let periods = try container.decode([OpenPeriod].self, forKey: .scheduled)
            self = .scheduled(periods: periods)
        default:
            var path = container.codingPath
            if let firstKey = container.allKeys.first {
                path.append(firstKey)
            }
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: path,
                    debugDescription: "Unabled to decode enum."
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
        case .scheduled(periods: let periods):
            try container.encode(periods, forKey: .scheduled)
        }
    }
}
