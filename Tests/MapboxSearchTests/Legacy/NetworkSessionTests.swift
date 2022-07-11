import XCTest
@testable import MapboxSearch

class NetworkSessionTests: XCTestCase {
    func testExample() throws {
        let task = URLSessionDataTask()
        let sessionStub: NetworkSession = DarwinNetworkSessionStub(sessionTask: task)
        let responseTask = sessionStub.dataTask(with: URLRequest(url: URL(string: "https://api.mapbox.com")!),
                                                                      completionHandler: { _, _, _ in })
        
        XCTAssert(task === responseTask)
    }
}
