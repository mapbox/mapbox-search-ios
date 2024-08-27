import CoreLocation
import Foundation

class SearchResultSuggestionImpl: SearchResultSuggestion, CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse

    let dataLayerIdentifier = SearchEngine.providerIdentifier

    var id: String

    var mapboxId: String?

    var name: String

    var address: Address?

    var iconName: String?

    var serverIndex: Int?

    var categories: [String]?

    var suggestionType: SearchSuggestType

    var descriptionText: String?
    var distance: CLLocationDistance?

    var estimatedTime: Measurement<UnitDuration>?

    let batchResolveSupported: Bool

    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        assert(
            coreResult.centerLocation == nil,
            "CoreSearchResult should not contain coordinate. Instantiate \(ServerSearchResult.self) instead."
        )

        guard coreResult.centerLocation == nil else { return nil }

        switch coreResult.resultTypes {
        case _ where CoreResultType.hasOnlyAddressSubtypes(types: coreResult.resultTypes):
            self.suggestionType = .address(subtypes: coreResult.resultTypes.compactMap(SearchAddressType.init))
        case [.query]:
            self.suggestionType = .query
        case [.poi]:
            self.suggestionType = .POI
        default:
            return nil
        }

        self.id = coreResult.id
        self.mapboxId = coreResult.mapboxId
        self.name = coreResult.names[0]
        self.address = coreResult.addresses?.first.map(Address.init)
        self.iconName = coreResult.icon
        self.serverIndex = coreResult.serverIndex?.intValue
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.distance = coreResult.distanceToProximity
        self.batchResolveSupported = coreResult.action?.multiRetrievable ?? false
        self.categories = coreResult.categories
        self.estimatedTime = coreResult.estimatedTime
        self.descriptionText = coreResult.addressDescription
        self.estimatedTime = coreResult.estimatedTime
    }
}
