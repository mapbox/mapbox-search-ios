import Foundation

extension CoreRequestOptions {
    static let sample1 = CoreRequestOptions(
        query: "sample-1",
        endpoint: "suggest",
        options: .sample1,
        proximityRewritten: false,
        originRewritten: false,
        sessionID: UUID().uuidString
    )
    static let sample2 = CoreRequestOptions(
        query: "sample-2",
        endpoint: "retrieve",
        options: .sample2,
        proximityRewritten: true,
        originRewritten: false,
        sessionID: UUID().uuidString
    )
}
