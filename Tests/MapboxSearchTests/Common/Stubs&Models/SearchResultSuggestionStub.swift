import CoreLocation
@testable import MapboxSearch

struct SearchResultSuggestionStub: SearchResultSuggestion {
    static let sample1 = SearchResultSuggestionStub(id: "sample-1")

    var dataLayerIdentifier: String = "tests-dataLayerIdentifier"

    var id: String = UUID().uuidString

    var name: String = "Name for UnitTests"

    var address: Address?

    var categories: [String]?

    var descriptionText: String? = "Test description text"

    var iconName: String? = Maki.bar.name

    var serverIndex: Int?

    var suggestionType: SearchSuggestType = .address(subtypes: [.address])

    var searchRequest: SearchRequestOptions = .sample1

    var distance: CLLocationDistance? = 300

    var batchResolveSupported = false
}
