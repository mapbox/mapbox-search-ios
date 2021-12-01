import Foundation

protocol CoreSearchResponseProtocol {
    var isIsSuccessful: Bool { get }

    var httpCode: Int32 { get }

    var message: String { get }

    var requestID: UInt32 { get }

    var request: CoreRequestOptions { get }

    var results: [CoreSearchResult] { get }
    
    var responseUUID: String { get }
}

extension CoreSearchResponse: CoreSearchResponseProtocol {}
