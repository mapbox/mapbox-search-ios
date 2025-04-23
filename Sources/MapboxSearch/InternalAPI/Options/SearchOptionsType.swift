import CoreLocation
import Foundation

public protocol SearchOptionsType {
    var countries: [String]? { get set }
    var languages: [String] { get set }
    var limit: Int? { get set }
    var fuzzyMatch: Bool? { get set }
    var proximity: CLLocationCoordinate2D? { get set }
    var boundingBox: BoundingBox? { get set }
    var origin: CLLocationCoordinate2D? { get set }
    var routeOptions: RouteOptions? { get set }
    var ignoreIndexableRecords: Bool { get set }
    var indexableRecordsDistanceThreshold: CLLocationDistance? { get set }
    var unsafeParameters: [String: String]? { get set }
    var locale: Locale? { get set }
    var attributeSets: [AttributeSet]? { get set }
    var requestDebounce: TimeInterval { get set }
    var navigationOptions: SearchNavigationOptions? { get set }
}

extension SearchOptions: SearchOptionsType {
    public var requestDebounce: TimeInterval {
        get { defaultDebounce }
        set { defaultDebounce = newValue }
    }
}

extension CategorySearchOptions: SearchOptionsType {}

extension SearchOptionsType {
    mutating func forceNilArg<Value>(
        _ keyPath: WritableKeyPath<Self, Value?>,
        message: String
    ) {
        if self[keyPath: keyPath] != nil {
            self[keyPath: keyPath] = nil
            _Logger.searchSDK.info(message)
        }
    }
}
