import Foundation
@_implementationOnly import MapboxCoreSearch
@testable import MapboxSearch
import Swifter
import XCTest

protocol MockResponse {
    /// Resource from test bundle containing response JSON.
    var filepath: String { get }

    /// HTTP Method used for this request, "GET" or "POST".
    var httpMethod: HttpServer.HTTPMethod { get }

    /// URL path for this request.
    var path: String { get }

    /// The API type for this mock.
    /// Uses Core types to support address autofill.
    static var coreApiType: CoreSearchEngine.ApiType { get }
}

// MARK: - Geocoding

enum GeocodingMockResponse: MockResponse {
    case forwardGeocoding
    case reverseGeocoding
    case reverseGeocodingSBS

    var filepath: String {
        let bundle = Bundle(for: MockWebServer<Self>.self)
        switch self {
        case .reverseGeocodingSBS:
            return bundle.path(forResource: "reverse-geocoding-sbs", ofType: "json")!
        case .reverseGeocoding:
            return bundle.path(forResource: "geocoding-reverse-geocoding", ofType: "json")!
        case .forwardGeocoding:
            return bundle.path(forResource: "mapbox.places.san.francisco", ofType: "json")!
        }
    }

    var path: String {
        var path = "/search/v1"
        switch self {
        case .forwardGeocoding:
            path = "/geocoding/v5/mapbox.places/:query"
        case .reverseGeocoding:
            path = "/geocoding/v5/mapbox.places/:location"

        case .reverseGeocodingSBS:
            path += "/:coordinates"
        }

        return path
    }

    var httpMethod: HttpServer.HTTPMethod {
        switch self {
        case .forwardGeocoding,
             .reverseGeocoding,
             .reverseGeocodingSBS:
            return .get
        }
    }

    static var coreApiType: CoreSearchEngine.ApiType {
        .geocoding
    }
}

// MARK: - SBS

enum SBSMockResponse: MockResponse {
    case suggestEmpty
    case suggestMinsk
    case suggestSanFrancisco
    case suggestCategories
    case suggestWithCoordinates
    case suggestWithMixedCoordinates
    case suggestCategoryWithCoordinates

    case retrieveSanFrancisco
    case retrieveMinsk
    case retrieveCategory
    case retrievePoi
    case multiRetrieve

    case recursion
    case categoryCafe
    case categoryHotelSearchAlongRoute_JP

    var filepath: String {
        let bundle = Bundle(for: MockWebServer<Self>.self)
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
        case .multiRetrieve:
            return bundle.path(forResource: "retrieve-multi", ofType: "json")!
        case .categoryCafe:
            return bundle.path(forResource: "category-cafe", ofType: "json")!
        case .categoryHotelSearchAlongRoute_JP:
            return bundle.path(forResource: "category-hotel-search-along-route-jp", ofType: "json")!
        }
    }

    var path: String {
        var path = "/search/v1"

        switch self {
        case .suggestMinsk:
            path += "/suggest/Minsk"

        case .suggestSanFrancisco:
            path += "/suggest/San Francisco"

        case .suggestEmpty,
             .suggestCategories,
             .suggestWithCoordinates,
             .suggestWithMixedCoordinates,
             .recursion,
             .suggestCategoryWithCoordinates:
            path += "/suggest/:query"

        case .retrieveSanFrancisco,
             .retrieveCategory,
             .retrieveMinsk,
             .retrievePoi:
            path += "/retrieve"

        case .multiRetrieve:
            path += "/retrieve/multi"

        case .categoryCafe,
             .categoryHotelSearchAlongRoute_JP:
            path += "/category/:category"
        }

        return path
    }

    var httpMethod: HttpServer.HTTPMethod {
        switch self {
        case .suggestMinsk,
             .suggestSanFrancisco,
             .suggestEmpty,
             .suggestCategories,
             .suggestWithCoordinates,
             .suggestWithMixedCoordinates,
             .suggestCategoryWithCoordinates,
             .recursion,
             .categoryCafe,
             .categoryHotelSearchAlongRoute_JP:
            return .get

        case .multiRetrieve,
             .retrieveSanFrancisco,
             .retrieveCategory,
             .retrieveMinsk,
             .retrievePoi:
            return .post
        }
    }

    static var coreApiType: CoreSearchEngine.ApiType {
        .SBS
    }
}

// MARK: - Autofill

enum AutofillMockResponse: MockResponse {
    case suggestAddressSanFrancisco
    case retrieveAddressSanFrancisco

    var filepath: String {
        let bundle = Bundle(for: MockWebServer<Self>.self)
        switch self {
        case .retrieveAddressSanFrancisco:
            return bundle.path(forResource: "address-retrieve-san-francisco", ofType: "json")!
        case .suggestAddressSanFrancisco:
            return bundle.path(forResource: "address-suggestions-san-francisco", ofType: "json")!
        }
    }

    var path: String {
        var path = "/search/v1"

        switch self {
        case .suggestAddressSanFrancisco:
            path = "/autofill/v1/suggest/:query"

        case .retrieveAddressSanFrancisco:
            path = "/autofill/v1/retrieve/:action.id"
        }

        return path
    }

    var httpMethod: HttpServer.HTTPMethod {
        switch self {
        case .suggestAddressSanFrancisco,
             .retrieveAddressSanFrancisco:
            return .get
        }
    }

    static var coreApiType: CoreSearchEngine.ApiType {
        .autofill
    }
}
