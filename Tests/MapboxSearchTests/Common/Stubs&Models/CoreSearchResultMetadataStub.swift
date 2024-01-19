import Foundation
@testable import MapboxSearch

class CoreSearchResultMetadataStub: CoreResultMetadataProtocol {
    init(
        data: [String: String],
        primaryImage: [CoreImageInfoProtocol]? = nil,
        otherImage: [CoreImageInfoProtocol]? = nil,
        description: String? = nil,
        averageRating: NSNumber? = nil,
        reviewCount: NSNumber? = nil,
        phone: String? = nil,
        website: String? = nil,
        openHours: CoreOpenHours? = nil
    ) {
        self.data = data
        self.primaryImage = primaryImage
        self.otherImage = otherImage
        self.description = description
        self.averageRating = averageRating
        self.reviewCount = reviewCount
        self.phone = phone
        self.website = website
        self.openHours = openHours
    }

    var data: [String: String]
    var primaryImage: [CoreImageInfoProtocol]?
    var otherImage: [CoreImageInfoProtocol]?
    var description: String?
    var averageRating: NSNumber?
    var reviewCount: NSNumber?
    var phone: String?
    var website: String?

    var openHours: CoreOpenHours?

    static let sample1 = CoreSearchResultMetadataStub(
        data: [
            "phone": "+1 23 34 5648",
            "website": "https://mapbox.com",
            "review_count": "42",
            "average_rating": "3.97",
        ],
        primaryImage: [
            CoreImageInfoStub.sample1,
            CoreImageInfoStub.sample2,
            CoreImageInfoStub.sample3,
        ],
        otherImage: [CoreImageInfoStub.sample4],
        description: "Test Description",
        averageRating: 4.5,
        reviewCount: 200,
        phone: "+ 000 00 000 00 00",
        website: "https://www.google.com"
    )
}
