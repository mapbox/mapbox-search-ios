import Foundation

class MockWebServer {
    
    let endpoint = "http://localhost:8080"
    
//    var eventLoop: EventLoop!
//    var router: Router!
//    var eventLoopThreadCondition: NSCondition!
//    var eventLoopThread: Thread!
//    var server: HTTPServer!
    
    func setResponse(_ response: MockResponse, query: String? = nil, statusCode: Int = 200) throws {
//        let json = try Data(contentsOf: URL(fileURLWithPath: response.path))
//        var route = "/search/v1/\(response.endpoint.rawValue)"
//
//        // Append query only for suggestions
//        if response.endpoint == .suggest {
//            let encodedQuery = query.flatMap { "/\($0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" } ?? ""
//            route.append(encodedQuery)
//        }
//
//        router[route] = JSONResponse(statusCode: statusCode, handler: { environ in
//            return try! JSONSerialization.jsonObject(with: json, options: [])
//        })
    }
    
    func setResponse(endpoint: MockResponse.Endpoint, body: String, statusCode: Int) {
//        let route = "/search/v1/\(endpoint.rawValue)"
//        router[route] = DataResponse(handler: { environ, sendData in
//            sendData(body.data(using: .utf8)!)
//        })
    }
    
    func start() throws {
//        eventLoop = try SelectorEventLoop(selector: try KqueueSelector())
//        router = Router()
//        server = DefaultHTTPServer(eventLoop: eventLoop, port: 8080, app: router.app)
//        try server.start()
//
//        eventLoopThreadCondition = NSCondition()
//        eventLoopThread = Thread(block: {
//            self.eventLoop.runForever()
//            self.eventLoopThreadCondition.lock()
//            self.eventLoopThreadCondition.signal()
//            self.eventLoopThreadCondition.unlock()
//        })
//        eventLoopThread.start()
    }
    
    func stop() {
//        server.stopAndWait()
//        eventLoopThreadCondition.lock()
//        eventLoop.stop()
//
//        while eventLoop.running {
//            if !eventLoopThreadCondition.wait(until: Date(timeIntervalSinceNow: 10)) {
//                fatalError("Join eventLoopThread timeout")
//            }
//        }
    }
}
