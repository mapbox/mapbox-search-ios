import Foundation

enum MockResponse {
    enum Endpoint: String {
        case suggest
        case retrieve
        case reverse
        case multiRetrieve = "retrieve/multi"
        case categoryCafe = "cafe"
        case categoryHotel = "hotel"
        case addressSuggest = "autofill/suggest"
        case addressRetrieve = "autofill/retrieve"
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
    case reverseGeocoding
    case categoryCafe
    case categoryHotelSearchAlongRoute_JP

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
        case .multiRetrieve:
            return bundle.path(forResource: "retrieve-multi", ofType: "json")!
        case .categoryCafe:
            return bundle.path(forResource: "category-cafe", ofType: "json")!
        case .categoryHotelSearchAlongRoute_JP:
            return bundle.path(forResource: "category-hotel-search-along-route-jp", ofType: "json")!
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

        case .suggestMinsk,
             .suggestEmpty,
             .suggestSanFrancisco,
             .suggestCategories,
             .suggestWithCoordinates,
             .suggestWithMixedCoordinates,
             .suggestCategoryWithCoordinates,
             .recursion:
            return .suggest

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
            return .categoryCafe

        case .categoryHotelSearchAlongRoute_JP:
            return .categoryHotel
        }
    }
}
