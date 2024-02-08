import Foundation
import Swifter

final class MockWebServer {
    let endpoint = "http://localhost:8080"

    private let server = HttpServer()

    func setResponse(_ response: MockResponse, query: String? = nil, statusCode: Int = 200) throws {
        let route = Self.path(for: response)
        let method = Self.httpMethod(for: response)

        let response = HttpResponse.raw(statusCode, "mocked response", nil) { writer in
            try writer.write(
                Data(contentsOf: URL(fileURLWithPath: response.filepath))
            )
        }

        switch method {
        case .get:
            server.get[route] = { _ in response }

        case .post:
            server.post[route] = { _ in response }
        }
    }

    func setResponse(endpoint: MockResponse, query: String? = nil, body: String, statusCode: Int) {
        let route = Self.path(for: endpoint)
        let method = Self.httpMethod(for: endpoint)

        let response = HttpResponse.raw(statusCode, "mocked response", nil) { writer in
            try writer.write(body.data(using: .utf8)!)
        }

        switch method {
        case .get:
            server.get[route] = { _ in response }

        case .post:
            server.post[route] = { _ in response }
        }
    }

    func start() throws {
        try server.start()
    }

    func stop() {
        server.stop()
    }
}

// MARK: - private

extension MockWebServer {
    fileprivate enum HTTPMethod {
        case get, post
    }

    fileprivate static func httpMethod(for response: MockResponse) -> HTTPMethod {
        switch response {
        case .suggestAddressSanFrancisco,
             .retrieveAddressSanFrancisco,
             .forwardGeocoding,
             .suggestMinsk,
             .suggestSanFrancisco,
             .suggestEmpty,
             .suggestCategories,
             .suggestWithCoordinates,
             .suggestWithMixedCoordinates,
             .suggestCategoryWithCoordinates,
             .recursion,
             .reverseGeocoding,
             .reverseGeocodingSBS,
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

    fileprivate static func path(for response: MockResponse) -> String {
        var path = "/search/v1"

        switch response {
        case .suggestAddressSanFrancisco:
            path = "/autofill/v1/suggest/:query"

        case .retrieveAddressSanFrancisco:
            path = "/autofill/v1/retrieve/:action.id"

        case .forwardGeocoding:
            path = "/geocoding/v5/mapbox.places/:query"

        case .suggestMinsk:
            path += "/suggest/Minsk"

        case .suggestSanFrancisco:
            path += "/suggest/San Francisco"

        case .suggestEmpty,
             .suggestCategories,
             .suggestWithCoordinates,
             .suggestWithMixedCoordinates,
             .suggestCategoryWithCoordinates,
             .recursion:
            path += "/suggest/:query"

        case .retrieveSanFrancisco,
             .retrieveCategory,
             .retrieveMinsk,
             .retrievePoi:
            path += "/retrieve"

        case .reverseGeocoding:
            path = "geocoding/v5/mapbox.places/:location"

        case .reverseGeocodingSBS:
            path += "/:coordinates"

        case .multiRetrieve:
            path += "/retrieve/multi"

        case .categoryCafe, .categoryHotelSearchAlongRoute_JP:
            path += "/category/:category"
        }

        return path
    }
}
