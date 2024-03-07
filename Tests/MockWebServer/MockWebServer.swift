import Foundation
import Swifter

final class MockWebServer<Mock: MockResponse> {
    let endpoint = "http://localhost:8080"

    private let server = HttpServer()

    func setResponse(_ endpoint: Mock, query: String? = nil, statusCode: Int = 200) throws {
        let route = endpoint.path
        let method = endpoint.httpMethod

        let response = HttpResponse.raw(statusCode, "mocked response", nil) { writer in
            try writer.write(
                Data(contentsOf: URL(fileURLWithPath: endpoint.filepath))
            )
        }

        switch method {
        case .get:
            server.get[route] = { _ in response }

        case .post:
            server.post[route] = { _ in response }
        }
    }

    func setResponse(endpoint: Mock, query: String? = nil, body: String, statusCode: Int) {
        let route = endpoint.path
        let method = endpoint.httpMethod

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

extension HttpServer {
    enum HTTPMethod {
        case get, post
    }
}
