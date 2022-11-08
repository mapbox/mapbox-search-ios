import Foundation
import CoreLocation

class ExternalRecordPlaceholder: SearchResultSuggestion, CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse
    
    var dataLayerIdentifier: String
    
    var id: String
    
    var name: String
    
    var address: Address?
    
    var descriptionText: String?
    
    var iconName: String?
    
    var serverIndex: Int?
    
    var categories: [String]?
    
    var suggestionType: SearchSuggestType = .POI
    
    var distance: CLLocationDistance?
    
    let batchResolveSupported: Bool
    
    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        guard let layerIdentifier = coreResult.layer, coreResult.resultTypes == [.userRecord] else { return nil }
        
        self.id = coreResult.userRecordID ?? coreResult.id
        self.name = coreResult.names[0]
        self.address = coreResult.addresses?.first.map(Address.init)
        self.dataLayerIdentifier = layerIdentifier
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.categories = coreResult.categories
        self.serverIndex = coreResult.serverIndex?.intValue
        
        /*
            It is not possible to calculate distance correctly for userRecords suggestions in case if navProfile is specified.
        */
        if response.request.options.navProfile != nil {
            self.distance = nil
        } else {
            self.distance = coreResult.distanceToProximity
        }
        
        self.descriptionText = coreResult.addresses?.first.map(Address.init)?.formattedAddress(style: .medium)
        self.batchResolveSupported = coreResult.action?.isMultiRetrievable ?? false
        
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
