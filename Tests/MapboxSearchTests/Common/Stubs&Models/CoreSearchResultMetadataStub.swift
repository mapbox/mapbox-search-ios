import Foundation
@testable import MapboxSearch

/// Test-only convenience
extension CoreResultMetadataProtocol {
    var priceLevel: String? { nil }
    var popularity: NSNumber? { nil }

    // MARK: Characteristics and Options

    var openHours: CoreOpenHours? { nil }
    var parkingData: CoreParkingData? { nil }
    var wheelchairAccessible: NSNumber? { nil }
    var delivery: NSNumber? { nil }
    var driveThrough: NSNumber? { nil }
    var reservable: NSNumber? { nil }
    var parkingAvailable: NSNumber? { nil }
    var valetParking: NSNumber? { nil }
    var streetParking: NSNumber? { nil }
    var servesBreakfast: NSNumber? { nil }
    var servesBrunch: NSNumber? { nil }
    var servesDinner: NSNumber? { nil }
    var servesLunch: NSNumber? { nil }
    var servesWine: NSNumber? { nil }
    var servesBeer: NSNumber? { nil }
    var servesVegan: NSNumber? { nil }
    var servesVegetarian: NSNumber? { nil }
    var takeout: NSNumber? { nil }

    // MARK: Social Media and Contact

    var facebookId: String? { nil }
    var fax: String? { nil }
    var email: String? { nil }
    var instagram: String? { nil }
    var twitter: String? { nil }
}

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
        openHours: CoreOpenHours? = nil,
        children: [CoreResultChildMetadata]? = nil
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
    var children: [CoreResultChildMetadata]?

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
