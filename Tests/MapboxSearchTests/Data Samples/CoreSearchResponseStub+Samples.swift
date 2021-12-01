import Foundation
@testable import MapboxSearch

extension CoreSearchResponseStub {
    static let failureSample = CoreSearchResponseStub(id: 377,
                                                      options: CoreRequestOptions.sample1,
                                                      result: .failure(
                                                        NSError(domain: mapboxCoreSearchErrorDomain,
                                                                code: 500,
                                                                userInfo: [NSLocalizedDescriptionKey: "Server Internal error"])))
    
    static func failureSample(error: NSError) -> CoreSearchResponseStub {
        CoreSearchResponseStub(id: 377,
                               options: CoreRequestOptions.sample1,
                               result: .failure(error)
        )
    }
    
    static func successSample(id: UInt32 = 8253, options: CoreRequestOptions = .sample1, results: [CoreSearchResultProtocol]) -> CoreSearchResponseStub {
        CoreSearchResponseStub(id: id,
                               options: .sample1,
                               result: .success(results))
    }
}
