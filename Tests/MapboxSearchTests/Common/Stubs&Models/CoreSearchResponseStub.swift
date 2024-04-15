import Foundation
@testable import MapboxSearch

class CoreSearchResponseStub {
    let options: CoreRequestOptions
    let result: Result<[CoreSearchResult], SearchError>
    let id: UInt32

    init(id: UInt32, options: CoreRequestOptions, result: Result<[CoreSearchResult], SearchError>) {
        self.result = result
        self.options = options
        self.id = id
    }
}

extension CoreSearchResponseStub: CoreSearchResponseProtocol {
    var isIsSuccessful: Bool {
        switch result {
        case .success: return true
        case .failure: return false
        }
    }

    var httpCode: Int32 {
        switch result {
        case .success:
            return 200
        case .failure(let error):
            return Int32(error.errorCode)
        }
    }

    var message: String {
        switch result {
        case .success:
            return ""
        case .failure(let error):
            return error.localizedDescription
        }
    }

    var request: CoreRequestOptions {
        return options
    }

    var results: [CoreSearchResult] {
        switch result {
        case .success(let result):
            return result
        case .failure:
            return []
        }
    }

    var responseUUID: String {
        "the_response_UUID"
    }
}
