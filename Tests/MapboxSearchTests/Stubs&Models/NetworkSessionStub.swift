import Foundation
@testable import MapboxSearch

class NetworkSessionStub: NetworkSession {
    var response: (data: Data?, response: URLResponse?, error: Error?) // swiftlint:disable:this large_tuple
    private(set) var request: URLRequest?
    
    init(response: (Data?, URLResponse?, Error?) = (nil, nil, nil)) { // swiftlint:disable:this large_tuple
        self.response = response
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionTask {
        self.request = request
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            completionHandler(self.response.data, self.response.response, self.response.error)
        }
        
        return NetworkSessionTaskStub(request: request)
    }
}
