import CoreLocation
import Foundation

protocol CoreSearchResultProtocol {
    var id: String { get }

    /// A unique identifier for the geographic feature
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

    var center: CLLocation? { get }

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
}

extension CoreSearchResult: CoreSearchResultProtocol {
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
}
