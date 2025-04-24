import CoreLocation
import Foundation

class SearchQuerySuggestionImpl: SearchQuerySuggestion, CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse

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

    var suggestionType: SearchSuggestType

    var distance: CLLocationDistance?

    var estimatedTime: Measurement<UnitDuration>?

    let batchResolveSupported: Bool

    var brand: [String]?

    var brandID: String?

    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        assert(coreResult.centerLocation == nil)

        guard coreResult.resultTypes == [.query] else { return nil }

        self.id = coreResult.id
        self.mapboxId = coreResult.mapboxId
        self.suggestionType = .query
        self.name = coreResult.names.first ?? ""
        self.namePreferred = coreResult.namePreferred
        self.address = coreResult.addresses?.first.map(Address.init)
        self.iconName = nil // Queries should use it's special icon
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.distance = coreResult.distanceToProximity
        self.batchResolveSupported = coreResult.action?.multiRetrievable ?? false
        self.categories = coreResult.categories
        self.categoryIds = coreResult.categoryIDs
        self.estimatedTime = coreResult.estimatedTime
        self.descriptionText = coreResult.addressDescription
        self.estimatedTime = coreResult.estimatedTime
        self.brand = coreResult.brand
        self.brandID = coreResult.brandID
    }
}
