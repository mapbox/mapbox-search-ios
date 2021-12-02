import Foundation

protocol NetworkSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionTask
}

protocol DarwinNetworkSession: NetworkSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: DarwinNetworkSession { }

extension DarwinNetworkSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionTask {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

protocol NetworkSessionTask: ProgressReporting {
    func suspend()
    func resume()
}

extension URLSessionTask: NetworkSessionTask { }
