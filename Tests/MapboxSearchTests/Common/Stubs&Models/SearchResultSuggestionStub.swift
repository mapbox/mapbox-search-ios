import CoreLocation
@testable import MapboxSearch

struct SearchResultSuggestionStub: SearchResultSuggestion {
    static let sample1 = SearchResultSuggestionStub(id: "sample-1")

    var dataLayerIdentifier: String = "tests-dataLayerIdentifier"

    var id: String = UUID().uuidString

    var mapboxId: String? = ""

    var name: String = "Name for UnitTests"

    var namePreferred: String? = "POI preferred name"

    var address: Address?

    var categories: [String]?

    var categoryIds: [String]?

    var descriptionText: String? = "Test description text"

    var iconName: String? = Maki.bar.name

    var serverIndex: Int?

    var suggestionType: SearchSuggestType = .address(subtypes: [.address])

    var searchRequest: SearchRequestOptions = .sample1

    var distance: CLLocationDistance? = 300

    var batchResolveSupported = false

    var estimatedTime: Measurement<UnitDuration>? = .init(value: 20, unit: .minutes)

    var brand: [String]?

    var brandID: String?
}
