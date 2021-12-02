import Foundation

enum MockResponse {
    
    enum Endpoint: String {
        case suggest = "suggest"
        case retrieve = "retrieve"
        case reverse = "reverse"
        case multiRetrieve = "retrieve/multi"
        case category = "category"
    }
    
    case suggestEmpty
    case suggestMinsk
    case suggestSanFrancisco
    case suggestCategories
    
    case retrieveSanFrancisco
    case retrieveMinsk
    case retrieveCategory
    case multiRetrieve
    
    case recursion
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
        case .retrieveSanFrancisco:
            return bundle.path(forResource: "retrieve-san-francisco", ofType: "json")!
        case .retrieveMinsk:
            return bundle.path(forResource: "retrieve-minsk", ofType: "json")!
        case .retrieveCategory:
            return bundle.path(forResource: "retrieve-category", ofType: "json")!
        case .recursion:
            return bundle.path(forResource: "recursion", ofType: "json")!
        case .reverseGeocoding:
            return bundle.path(forResource: "reverse-geocoding", ofType: "json")!
        case .multiRetrieve:
            return bundle.path(forResource: "retrieve-multi", ofType: "json")!
        case .categoryCafe:
            return bundle.path(forResource: "category-cafe", ofType: "json")!
        }
    }
    
    var endpoint: Endpoint {
        switch self {
        case .suggestMinsk,
             .suggestEmpty,
             .suggestSanFrancisco,
             .suggestCategories,
             .recursion:
            return .suggest
            
        case .retrieveSanFrancisco,
             .retrieveCategory,
             .retrieveMinsk:
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
