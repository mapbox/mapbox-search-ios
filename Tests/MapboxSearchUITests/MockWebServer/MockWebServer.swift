import Foundation
import Swifter

final class MockWebServer {
    let endpoint = "http://localhost:8080"

    private let server = HttpServer()

    func setResponse(_ response: MockResponse, query: String? = nil, statusCode: Int = 200) throws {
        let route = Self.path(for: response.endpoint)
        let method = Self.httpMethod(for: response.endpoint)

        let response = HttpResponse.raw(statusCode, "mocked response", nil) { writer in
            try writer.write(
                Data(contentsOf: URL(fileURLWithPath: response.path))
            )
        }

        switch method {
        case .get:
            server.get[route] = { _ in response }

        case .post:
            server.post[route] = { _ in response }
        }
    }

    func setResponse(endpoint: MockResponse.Endpoint, query: String? = nil, body: String, statusCode: Int) {
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

    fileprivate static func httpMethod(for endpoint: MockResponse.Endpoint) -> HTTPMethod {
        switch endpoint {
        case .suggest, .categoryCafe, .reverse, .addressSuggest, .addressRetrieve:
            return .get

        case .retrieve, .multiRetrieve, .categoryHotel:
            return .post
        }
    }

    fileprivate static func path(for endpoint: MockResponse.Endpoint) -> String {
        var path = "/search/v1/\(endpoint.rawValue)"

        switch endpoint {
        case .suggest:
            path += "/:query"

        case .categoryCafe,
             .categoryHotel:
            path = "search/v1/category/\(endpoint.rawValue)"

        case .multiRetrieve:
            break

        case .reverse:
            path += "/:coordinates"

        case .retrieve:
            break

        case .addressSuggest:
            path = "/autofill/v1/suggest/:query"

        case .addressRetrieve:
            path = "/autofill/v1/retrieve/:action.id"
        }

        return path
    }
}
