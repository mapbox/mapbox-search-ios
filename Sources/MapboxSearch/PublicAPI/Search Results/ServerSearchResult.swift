import CoreLocation
import Foundation

class ServerSearchResult: SearchResult, SearchResultSuggestion, CoreResponseProvider {
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

    var distance: CLLocationDistance?

    var categories: [String]?

    var routablePoints: [RoutablePoint]?

    let dataLayerIdentifier = SearchEngine.providerIdentifier

    var id: String

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
        guard let center = coreResult.centerLocation else { return nil }

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
        self.coordinateCodable = .init(center.coordinate)
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)

        let proximityValue = response.request.options.proximity?.value
        let proximityLocation = proximityValue.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        self.distance = coreResult.distanceToProximity ?? proximityLocation?.distance(from: center)
        self.routablePoints = coreResult.routablePoints?.map(RoutablePoint.init)
        self.batchResolveSupported = coreResult.action?.multiRetrievable ?? false
        self.descriptionText = coreResult.addressDescription

        assert(!id.isEmpty)
        assert(!name.isEmpty)
        assert(address != nil)
    }
}
