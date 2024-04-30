import CoreLocation
import Foundation

class ServerSearchResult: SearchResult, SearchResultSuggestion, CoreResponseProvider {
    var distance: CLLocationDistance?

    var originalResponse: CoreSearchResultResponse

    var coordinate: CLLocationCoordinate2D {
        get {
            coordinateCodable.coordinates
        }
        set {
            coordinateCodable = .init(newValue)
        }
    }

    var estimatedTime: Measurement<UnitDuration>?

    var metadata: SearchResultMetadata?

    var serverIndex: Int?

    var accuracy: SearchResultAccuracy?

    var coordinateCodable: CLLocationCoordinate2DCodable

    var address: Address?

    var categories: [String]?

    var routablePoints: [RoutablePoint]?

    let dataLayerIdentifier = SearchEngine.providerIdentifier

    var id: String

    /// A unique identifier for the geographic feature
    var mapboxId: String?

    var name: String

    var matchingName: String?

    var descriptionText: String?

    var iconName: String?

    var type: SearchResultType

    let batchResolveSupported: Bool

    var suggestionType: SearchSuggestType {
        switch type {
        case .POI: return .POI
        case .address(let subtypes): return .address(subtypes: subtypes)
        }
    }

    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        guard let coordinate = coreResult.center?.coordinate else { return nil }

        guard let type = SearchResultType(coreResultTypes: coreResult.resultTypes) else { return nil }
        self.type = type

        self.id = coreResult.id
        self.mapboxId = coreResult.mapboxId
        self.name = coreResult.names[0]
        self.matchingName = coreResult.matchingName
        self.iconName = coreResult.icon
        self.estimatedTime = coreResult.estimatedTime
        self.metadata = coreResult.metadata.map(SearchResultMetadata.init)
        self.serverIndex = coreResult.serverIndex?.intValue
        self.accuracy = coreResult.resultAccuracy.flatMap(SearchResultAccuracy.from(coreAccuracy:))
        self.address = coreResult.addresses?.first.map(Address.init)
        self.categories = coreResult.categories
        self.coordinateCodable = .init(coordinate)
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.distance = coreResult.distanceToProximity ??
            response.request.options.proximity?.distance(from: CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            ))
        self.routablePoints = coreResult.routablePoints?.map(RoutablePoint.init)
        self.batchResolveSupported = coreResult.action?.isMultiRetrievable ?? false
        self.descriptionText = coreResult.addressDescription

        assert(!id.isEmpty)
        assert(!name.isEmpty)
        assert(address != nil)
    }
}
