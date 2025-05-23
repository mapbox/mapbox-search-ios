import CoreLocation
import Foundation

class ExternalRecordPlaceholder: SearchResultSuggestion, CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse

    var dataLayerIdentifier: String

    var id: String

    var mapboxId: String?

    var name: String

    var namePreferred: String?

    var address: Address?

    var descriptionText: String?

    var iconName: String?

    var serverIndex: Int?

    var categories: [String]?

    var categoryIds: [String]?

    var suggestionType: SearchSuggestType = .POI

    var distance: CLLocationDistance?

    var estimatedTime: Measurement<UnitDuration>?

    let batchResolveSupported: Bool

    var brand: [String]?

    var brandID: String?

    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        guard let layerIdentifier = coreResult.layer, coreResult.resultTypes == [.userRecord] else { return nil }

        self.id = coreResult.userRecordID ?? coreResult.id
        self.mapboxId = coreResult.mapboxId
        self.name = coreResult.names.first ?? ""
        self.namePreferred = coreResult.namePreferred
        self.address = coreResult.addresses?.first.map(Address.init)
        self.dataLayerIdentifier = layerIdentifier
        self.distance = coreResult.distanceToProximity
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.categories = coreResult.categories
        self.categoryIds = coreResult.categoryIDs
        self.serverIndex = coreResult.serverIndex?.intValue
        self.estimatedTime = coreResult.estimatedTime
        self.descriptionText = coreResult.addresses?.first.map(Address.init)?.formattedAddress(style: .medium)
        self.batchResolveSupported = coreResult.action?.multiRetrievable ?? false
        self.estimatedTime = coreResult.estimatedTime

        switch layerIdentifier {
        case HistoryProvider.providerIdentifier:
            self.iconName = "history icon"
        case FavoritesProvider.providerIdentifier:
            self.iconName = "favorite icon"
        default:
            self.iconName = coreResult.icon
        }
    }
}
