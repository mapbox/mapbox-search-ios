import Foundation

enum MockResponse {
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
    case reverseGeocodingSBS
    case categoryCafe

    var filepath: String {
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
        case .reverseGeocodingSBS:
            return bundle.path(forResource: "reverse-geocoding-sbs", ofType: "json")!
        case .reverseGeocoding:
            return bundle.path(forResource: "geocoding-reverse-geocoding", ofType: "json")!
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
}
