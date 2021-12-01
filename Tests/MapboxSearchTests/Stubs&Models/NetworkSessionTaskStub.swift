import Foundation
@testable import MapboxSearch

class NetworkSessionTaskStub: NSObject, NetworkSessionTask {
    enum State {
        case suspended, resumed
    }
    
    var progress: Progress
    var state: State = .suspended
    var request: URLRequest
    
    init(request: URLRequest, progress: Progress = .init(totalUnitCount: 100)) {
        self.request = request
        self.progress = progress
    }
    
    func suspend() {
        state = .suspended
    }
    
    func resume() {
        state = .resumed
    }
}
