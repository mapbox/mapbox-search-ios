import Foundation

enum MockResponse {
    enum Endpoint {
        case suggest(query: String)
        case retrieve
        case reverse
        case forwardGeocoding
        case multiRetrieve
        case category
        case addressSuggest
        case addressRetrieve

        var value: String {
            switch self {
            case .suggest(let query):
                return "suggest/\(query)"
            case .retrieve:
                return "retrieve"
            case .reverse:
                return "reverse"
            case .forwardGeocoding:
                return "forwardGeocoding"
            case .multiRetrieve:
                return "multiRetrieve"
            case .category:
                return "category"
            case .addressSuggest:
                return "addressSuggest"
            case .addressRetrieve:
                return "addressRetrieve"
            }
        }
    }

    case suggestEmpty
    case suggestMinsk
    case suggestSanFrancisco
    case suggestCategories
    case suggestWithCoordinates
    case suggestWithMixedCoordinates
    case suggestCategoryWithCoordinates
    case suggestAddressSanFrancisco

    case retrieveSanFrancisco
    case retrieveMinsk
    case retrieveCategory
    case retrievePoi
    case multiRetrieve
    case retrieveAddressSanFrancisco

    case recursion
    case forwardGeocoding
    case reverseGeocoding
    case categoryCafe

    var path: String {
        let bundle = Bundle(for: MockWebServer.self)
        switch self {
        case .suggestEmpty:
            return bundle.path(forResource: "suggestions-empty", ofType: "json")!
        case .suggestMinsk:
            return bundle.path(forResource: "suggestions-minsk", ofType: "json")!
        case .suggestSanFrancisco:
            return bundle.path(forResource: "suggestions-san-francisco", ofType: "json")!
        case .suggestCategories:
            return bundle.path(forResource: "suggestions-categories", ofType: "json")!
        case .suggestWithCoordinates:
            return bundle.path(forResource: "suggestions-with-coordinates", ofType: "json")!
        case .suggestWithMixedCoordinates:
            return bundle.path(forResource: "suggestions-with-mixed-coordinates", ofType: "json")!
        case .suggestCategoryWithCoordinates:
            return bundle.path(forResource: "suggestions-category-with-coordinates", ofType: "json")!
        case .retrieveSanFrancisco:
            return bundle.path(forResource: "retrieve-san-francisco", ofType: "json")!
        case .retrieveMinsk:
            return bundle.path(forResource: "retrieve-minsk", ofType: "json")!
        case .retrieveCategory:
            return bundle.path(forResource: "retrieve-category", ofType: "json")!
        case .retrievePoi:
            return bundle.path(forResource: "retrieve-poi", ofType: "json")!
        case .recursion:
            return bundle.path(forResource: "recursion", ofType: "json")!
        case .reverseGeocoding:
            return bundle.path(forResource: "reverse-geocoding", ofType: "json")!
        case .forwardGeocoding:
            return bundle.path(forResource: "mapbox.places.san.francisco", ofType: "json")!
        case .multiRetrieve:
            return bundle.path(forResource: "retrieve-multi", ofType: "json")!
        case .categoryCafe:
            return bundle.path(forResource: "category-cafe", ofType: "json")!
        case .suggestAddressSanFrancisco:
            return bundle.path(forResource: "address-suggestions-san-francisco", ofType: "json")!
        case .retrieveAddressSanFrancisco:
            return bundle.path(forResource: "address-retrieve-san-francisco", ofType: "json")!
        }
    }

    var endpoint: Endpoint {
        switch self {
        case .suggestAddressSanFrancisco:
            return .addressSuggest

        case .retrieveAddressSanFrancisco:
            return .addressRetrieve

        case .forwardGeocoding:
            return .forwardGeocoding

        case .suggestMinsk:
            return .suggest(query: "Minsk")

        case .suggestSanFrancisco:
            return .suggest(query: "San Francisco")

        case .suggestEmpty,
             .suggestCategories,
             .suggestWithCoordinates,
             .suggestWithMixedCoordinates,
             .suggestCategoryWithCoordinates,
             .recursion:
            return .suggest(query: "")

        case .retrieveSanFrancisco,
             .retrieveCategory,
             .retrieveMinsk,
             .retrievePoi:
            return .retrieve

        case .reverseGeocoding:
            return .reverse

        case .multiRetrieve:
            return .multiRetrieve

        case .categoryCafe:
            return .category
        }
    }
}
