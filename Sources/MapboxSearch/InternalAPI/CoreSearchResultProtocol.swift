import CoreLocation
import Foundation

protocol CoreSearchResultProtocol {
    var id: String { get }

    var mapboxId: String? { get }

    var resultTypes: [CoreResultType] { get }

    /**
     @name \a names and \a addresses arrays match with \a languages array.
     */
    var names: [String] { get }

    var resultAccuracy: CoreAccuracy? { get }

    var languages: [String] { get }

    var addresses: [CoreAddress]? { get }

    var addressDescription: String? { get }

    var matchingName: String? { get }

    var centerLocation: CLLocation? { get }

    var estimatedTime: Measurement<UnitDuration>? { get }

    var metadata: CoreResultMetadata? { get }

    var categories: [String]? { get }

    var icon: String? { get }

    var routablePoints: [CoreRoutablePoint]? { get }

    /**
     @name Valid if result was created from UserRecord.
     */
    var layer: String? { get }

    var userRecordID: String? { get }

    /**
     @name Private parameters.
     */
    var action: CoreSuggestAction? { get }

    /** @brief Index in response from server (rank?). */
    var serverIndex: NSNumber? { get }

    var distance: NSNumber? { get }
    var distanceToProximity: CLLocationDistance? { get }

    /// The map of external ids.
    var externalIds: [String: String]? { get }

    /// The list of Category IDs that this result belongs to
    var categoryIDs: [String]? { get }
}

extension CoreSearchResult: CoreSearchResultProtocol {
    var centerLocation: CLLocation? {
        center.map { CLLocation(latitude: $0.value.latitude, longitude: $0.value.longitude) }
    }

    var resultTypes: [CoreResultType] {
        types.compactMap { CoreResultType(rawValue: $0.intValue) }
    }

    var estimatedTime: Measurement<UnitDuration>? {
        eta.map { Measurement(value: $0.doubleValue, unit: UnitDuration.minutes) }
    }

    var distanceToProximity: CLLocationDistance? {
        distance.map(\.doubleValue)
    }

    var resultAccuracy: CoreAccuracy? {
        accuracy.flatMap { CoreAccuracy(rawValue: $0.intValue) }
    }

    var addressDescription: String? { descrAddress }

    var externalIds: [String: String]? { externalIDs }
}
