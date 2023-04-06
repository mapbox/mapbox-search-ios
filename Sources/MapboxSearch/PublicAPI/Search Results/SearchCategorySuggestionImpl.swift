import Foundation
import CoreLocation

class SearchCategorySuggestionImpl: SearchCategorySuggestion, CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse
    
    var id: String
    
    var name: String
    
    var address: Address?
    
    var descriptionText: String?
    
    var iconName: String?
    
    var serverIndex: Int?
    
    var suggestionType: SearchSuggestType
    
    var categories: [String]?

    var estimatedTime: Measurement<UnitDuration>?
    
    var distance: CLLocationDistance?
    
    let batchResolveSupported: Bool

    var categoryCanonicalName: String?
    
    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        assert(coreResult.center == nil)
        
        guard coreResult.resultTypes == [.category] else { return nil }
        
        self.id = coreResult.id
        self.suggestionType = .category
        self.name = coreResult.names[0]
        self.address = coreResult.addresses?.first.map(Address.init)
        self.iconName = nil // Categories should use it's special icon
        self.serverIndex = coreResult.serverIndex?.intValue
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.estimatedTime = coreResult.estimatedTime
        self.distance = coreResult.distanceToProximity
        self.batchResolveSupported = coreResult.action?.isMultiRetrievable ?? false
        self.categories = coreResult.categories

        if let externalValue = coreResult.externalIds?[Constants.externalIdCategoryKey],
           externalValue.hasPrefix(Constants.categoryCanonicalNamePrefix) {
            self.categoryCanonicalName = String(externalValue.dropFirst(Constants.categoryCanonicalNamePrefix.count))
        }
        
        self.descriptionText = coreResult.addressDescription
    }

    enum Constants {
        static let externalIdCategoryKey = "federated"
        static let categoryCanonicalNamePrefix = "category."
    }
}
