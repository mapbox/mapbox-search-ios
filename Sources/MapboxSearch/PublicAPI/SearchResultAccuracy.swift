import Foundation

/// A point accuracy metric for the returned address feature.
public enum SearchResultAccuracy: String, Codable {
    /// Result is an approximate location.
    case approximate

    /// Result has been interpolated from an address range.
    case interpolated

    ///  Result is for a block or intersection.
    case intersection

    /// Result is derived from a parcel centroid.
    case parcel

    /// Result is a known address point but has no specific accuracy.
    case point

    /// Result is a known address point but does not intersect a known rooftop/parcel.
    case proximate

    /// Result is for a specific building/entrance.
    case rooftop

    /// Result is a street centroid.
    case street
}

extension SearchResultAccuracy {
    static func from(coreAccuracy: CoreAccuracy) -> Self? {
        switch coreAccuracy {
        case .approximate: return .approximate
        case .interpolated: return .interpolated
        case .intersection: return .intersection
        case .parcel: return .parcel
        case .point: return .point
        case .rooftop: return .rooftop
        case .street: return .street
        case .proximate: return .proximate

        @unknown default:
            return nil
        }
    }
}
