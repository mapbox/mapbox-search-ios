// Copyright © 2024 Mapbox. All rights reserved.

import CoreLocation
import Foundation

protocol SearchBrandSuggestion: SearchSuggestion {
    var externalIDs: [String: String]? { get }
}

class SearchBrandSuggestionImpl: SearchBrandSuggestion, CoreResponseProvider {
    var originalResponse: CoreSearchResultResponse

    var id: String

    var mapboxId: String?

    var name: String

    var address: Address?

    var descriptionText: String?

    var iconName: String?

    var serverIndex: Int?

    var suggestionType: SearchSuggestType

    var categories: [String]?

    var categoryIDs: [String]?

    var distance: CLLocationDistance?

    let batchResolveSupported: Bool

    var estimatedTime: Measurement<UnitDuration>?

    var brand: [String]?

    var brandID: String?

    var externalIDs: [String: String]?

    init?(coreResult: CoreSearchResultProtocol, response: CoreSearchResponseProtocol) {
        assert(coreResult.centerLocation == nil)

        guard coreResult.resultTypes == [.category] else { return nil }

        self.id = coreResult.id
        self.mapboxId = coreResult.mapboxId
        self.suggestionType = .category
        self.name = coreResult.names[0]
        self.address = coreResult.addresses?.first.map(Address.init)
        self.iconName = nil // Categories should use it's special icon
        self.serverIndex = coreResult.serverIndex?.intValue
        self.originalResponse = CoreSearchResultResponse(coreResult: coreResult, response: response)
        self.distance = coreResult.distanceToProximity
        self.batchResolveSupported = coreResult.action?.multiRetrievable ?? false
        self.categories = coreResult.categories
        self.categoryIDs = coreResult.categoryIDs

        self.descriptionText = coreResult.addressDescription
        self.estimatedTime = coreResult.estimatedTime

        self.brand = coreResult.brand
        self.brandID = coreResult.brandID
        self.externalIDs = coreResult.externalIds
    }
}
