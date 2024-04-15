import Foundation

/// Navigation Profiles to calculate route ETA
public enum SearchNavigationProfile: Hashable {
    /// Driving by car profile
    case driving

    /// Bicycle drive profile
    case cycling

    /// Walking profile
    case walking

    /// Custom navigation profile to be send to the server
    case custom(String)

    var string: String {
        switch self {
        case .driving:
            return "driving"
        case .cycling:
            return "cycling"
        case .walking:
            return "walking"
        case .custom(let value):
            return value
        }
    }

    init(coreValue: String) {
        switch coreValue.lowercased() {
        case "driving":
            self = .driving
        case "cycling":
            self = .cycling
        case "walking":
            self = .walking
        default:
            self = .custom(coreValue)
        }
    }
}
