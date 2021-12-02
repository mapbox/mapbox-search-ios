import Foundation

/// Types of error during adding offline region to the index
public enum AddOfflineRegionError: Error {
    /// General region failure with description in associated value
    case addOfflineRegionFailure(String)
}
