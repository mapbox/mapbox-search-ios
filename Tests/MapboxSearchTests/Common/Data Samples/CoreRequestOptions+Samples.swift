import Foundation
@testable import MapboxSearch

extension CoreRequestOptions {
    static let sampleQuery1 = "sample-1"
    static let sampleQuery2 = "sample-2"

    static let sample1 = CoreRequestOptions(
        query: sampleQuery1,
        endpoint: "suggest",
        options: .sample1,
        proximityRewritten: false,
        originRewritten: false,
        sessionID: UUID().uuidString
    )
    static let sample2 = CoreRequestOptions(
        query: sampleQuery2,
        endpoint: "retrieve",
        options: .sample2,
        proximityRewritten: true,
        originRewritten: false,
        sessionID: UUID().uuidString
    )
}
