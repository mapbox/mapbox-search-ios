import Foundation
@testable import MapboxSearch

class DarwinNetworkSessionStub: DarwinNetworkSession {
    let sessionTask: URLSessionDataTask
    
    init(sessionTask: URLSessionDataTask) {
        self.sessionTask = sessionTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return sessionTask
    }
}
