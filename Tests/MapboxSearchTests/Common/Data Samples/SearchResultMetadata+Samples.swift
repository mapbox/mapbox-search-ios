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
            rating: 3.9,
            reviewCount: 1_300,
            phone: "+ 123 45 678 91 23",
            website: "https://www.pizzahut.com"
        )
    )
}

extension CoreResultMetadata {
    static func make(data: [String: String] = [:]) -> CoreResultMetadata {
        CoreResultMetadata(
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
            children: nil,
            data: data,
            wheelchairAccessible: nil,
            delivery: nil,
            driveThrough: nil,
            reservable: nil,
            parkingAvailable: nil,
            valetParking: nil,
            streetParking: nil,
            parkingType: nil,
            servesBreakfast: nil,
            servesBrunch: nil,
            servesDinner: nil,
            servesLunch: nil,
            servesWine: nil,
            servesBeer: nil,
            takeout: nil,
            facebookId: nil,
            fax: nil,
            email: nil,
            instagram: nil,
            twitter: nil,
            priceLevel: nil,
            servesVegan: nil,
            servesVegetarian: nil,
            rating: nil,
            popularity: nil,
            evMetadata: nil,
            directions: nil,
            facilities: nil,
            timezone: nil,
            lastUpdated: nil,
            cuisines: nil
        )
    }
}
