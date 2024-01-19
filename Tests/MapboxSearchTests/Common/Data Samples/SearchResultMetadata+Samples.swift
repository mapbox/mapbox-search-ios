import Foundation
@testable import MapboxSearch

extension SearchResultMetadata {
    static let pizzaMetadata = SearchResultMetadata(
        metadata: CoreSearchResultMetadataStub(
            data: [
                "phone": "+14157953040",
                "website": "https://www.montesacropinseria.com/san-francisco",
                "review_count": "955",
                "average_rating": "4.6",
            ],
            primaryImage: [
                CoreImageInfoStub.sample1,
                CoreImageInfoStub.sample3,
            ],
            otherImage: [CoreImageInfoStub.sample4],
            description: "Pizza description",
            averageRating: 3.9,
            reviewCount: 1300,
            phone: "+ 123 45 678 91 23",
            website: "https://www.pizzahut.com"
        )
    )
}

extension CoreResultMetadata {
    static func make(data: [String: String] = [:]) -> CoreResultMetadata {
        .init(
            reviewCount: nil,
            phone: nil,
            website: nil,
            avRating: nil,
            description: nil,
            openHours: nil,
            primaryPhoto: nil,
            otherPhoto: nil,
            cpsJson: nil,
            parking: nil,
            data: data
        )
    }
}
