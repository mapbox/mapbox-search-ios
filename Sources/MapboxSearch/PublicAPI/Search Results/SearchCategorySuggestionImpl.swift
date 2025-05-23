import CoreLocation
import Foundation

class SearchCategorySuggestionImpl: SearchCategorySuggestion, CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse

    var id: String

    var mapboxId: String?

    var name: String

    var namePreferred: String?

    var address: Address?

    var descriptionText: String?

    var iconName: String?

    var serverIndex: Int?

    var suggestionType: SearchSuggestType

    var categories: [String]?

    var categoryIds: [String]?

    var distance: CLLocationDistance?

    let batchResolveSupported: Bool

    var estimatedTime: Measurement<UnitDuration>?

    var categoryCanonicalName: String?

    var brand: [String]?

    var brandID: String?

    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        assert(coreResult.centerLocation == nil)

        guard coreResult.resultTypes == [.category] else { return nil }

        self.id = coreResult.id
        self.mapboxId = coreResult.mapboxId
        self.suggestionType = .category
        self.name = coreResult.names.first ?? ""
        self.namePreferred = coreResult.namePreferred
        self.address = coreResult.addresses?.first.map(Address.init)
        self.iconName = nil // Categories should use it's special icon
        self.serverIndex = coreResult.serverIndex?.intValue
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.distance = coreResult.distanceToProximity
        self.batchResolveSupported = coreResult.action?.multiRetrievable ?? false
        self.categories = coreResult.categories
        self.categoryIds = coreResult.categoryIDs

        self.descriptionText = coreResult.addressDescription
        self.estimatedTime = coreResult.estimatedTime

        self.brand = coreResult.brand
        self.brandID = coreResult.brandID

        if let externalValue = coreResult.externalIds?[Constants.externalIdCategoryKey],
           externalValue.hasPrefix(Constants.categoryCanonicalNamePrefix)
        {
            self.categoryCanonicalName = String(externalValue.dropFirst(Constants.categoryCanonicalNamePrefix.count))
        }
    }

    private enum Constants {
        static let externalIdCategoryKey = "federated"
        static let categoryCanonicalNamePrefix = "category."
    }
}
