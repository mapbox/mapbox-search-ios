import CoreLocation
import Foundation

/// Options to configure Route for search along the route functionality
public struct RouteOptions: Hashable {
    /// This enum describes how far from the route we can look for results
    public enum Deviation: Hashable {
        /// Types of Search-Along-the-Route calculation quality
        public enum SARType: CaseIterable {
            /// Makes calculation more precise but also more expensive
            case isochrone
            /// Uses default server calculation logic
            case none

            func toCore() -> String? {
                return [.isochrone: "isochrone"][self]
            }

            init(coreValue: String?) {
                self = SARType.allCases.first(where: { $0.toCore() == coreValue }) ?? .none
            }
        }

        /// Maximum detour in seconds.
        case time(Measurement<UnitDuration>, SARType)

        var time: TimeInterval? {
            switch self {
            case .time(let time, _): return time.converted(to: .seconds).value
            }
        }

        var sarType: SARType? {
            switch self {
            case .time(_, let type):
                return type
            }
        }
    }

    /// Route to search along
    public let route: Route

    /// Route deviation parameters
    /// - Note: See also `RouteOptions.Deviation`
    public let deviation: Deviation

    /// Construct Route Options with custom deviation
    /// - Parameters:
    ///   - route: Route with coordinates
    ///   - deviation: Route deviation
    public init(route: Route, deviation: Deviation) {
        self.route = route
        self.deviation = deviation
    }

    /// Construct Route Options with Time route deviation
    /// - Parameters:
    ///   - route: Route with coordinates
    ///   - time: Time route deviation
    ///   - sarType: Quality of deviation calculation (better cost more). Defaults to `.isochrone`
    public init(route: Route, time: TimeInterval, sarType: Deviation.SARType = .isochrone) {
        self.init(route: route, deviation: .time(Measurement(value: time, unit: .seconds), sarType))
    }
}
