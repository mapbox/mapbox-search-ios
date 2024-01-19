import Foundation

/// Additional search options to improve navigation experience
/// It's possible to request estimated time of arrival according to a specific navigation profile
/// or change search ranking logic by the navigation details
public struct SearchNavigationOptions: Hashable {
    /// Requested type of ETA field
    /// Better quality type may lead to an extra cost
    public enum ETAType: CaseIterable {
        /// Calculate ETA as navigation.`CategorySearchEngine` doesn't support that option.
        case navigation

        /// Do not request ETA calculation.
        case none

        func toCore() -> String? {
            switch self {
            case .navigation: return "navigation"
            case .none: return nil
            }
        }

        init(coreValue: String?) {
            self = ETAType.allCases.first(where: { $0.toCore() == coreValue }) ?? .none
        }
    }

    /// Navigation profile option used for proper calculation of ETA
    public var profile: SearchNavigationProfile

    /// This indicates that the caller intends to perform a higher cost navigation ETA estimate.
    /// This along with `SearchOptions.origin` and `SearchNavigationOptions.profile` is required in order receive ETA
    /// estimates.
    public var etaType: ETAType

    /// Instantiate `SearchNavigationOptions` with optional ETA type (defaults to `.none`)
    public init(profile: SearchNavigationProfile, etaType: ETAType = .none) {
        self.profile = profile
        self.etaType = etaType
    }
}
