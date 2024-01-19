import CoreLocation
@testable import MapboxSearch

struct SearchSuggestionStub: SearchSuggestion {
    var id: String = UUID().uuidString
    var name: String = "Test Name"
    var categories: [String]?
    var descriptionText: String? = "Test Description"
    var address: Address?
    var iconName: String?
    var serverIndex: Int?
    var suggestionType: SearchSuggestType = .address(subtypes: [.place])
    var searchRequest = SearchRequestOptions(query: "test", proximity: nil)
    var distance: CLLocationDistance?
    var batchResolveSupported: Bool = false
}
