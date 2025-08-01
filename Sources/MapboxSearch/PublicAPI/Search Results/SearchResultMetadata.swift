import CoreGraphics
import Foundation

/// SearchResult additional information, such as phone, website and etc.
/// Extra metadata contained in data field as dictionary.
public struct SearchResultMetadata: Codable, Hashable {
    /// Metadata extra data.
    public var data: [String: String]

    /// Child metadata for a POI
    public var children: [ResultChildMetadata]?

    /// SearchResult primary photos
    public var primaryImage: Image?

    /// Additional photos
    public var otherImages: [Image]?

    /// Business phone number
    public var phone: String?

    /// Business website
    public var website: URL?

    /// Number of reviews
    public var reviewCount: Int?

    /// The average rating of the location, on a scale from 1 to 5.
    public var rating: Double?

    /// The average rating of the location, on a scale from 1 to 5.
    /// **Deprecated**: Please use the ``rating`` field for this value.
    public var averageRating: Double?

    /// Business opening hours
    public var openHours: OpenHours?

    // MARK: Characteristics and Options

    /// Long form detailed description for POI.
    public var description: String?

    /// The price level of the location, represented by a string including dollar signs. The values scale from Cheap "$"
    /// to Most Expensive "$$$$".
    public var priceLevel: String?

    /// A popularity score for the location, calculated based on user engagement and review counts. The value scales
    /// from 0 to 1, 1 being the most popular.
    public var popularity: Float?

    /// Indicates whether the location is accessible by wheelchair.
    public var wheelchairAccessible: Bool?

    /// Indicates whether the location offers delivery services.
    public var delivery: Bool?

    /// Indicates whether the location has a drive-through service.
    public var driveThrough: Bool?

    /// Indicates whether the location accepts reservations.
    public var reservable: Bool?

    /// Indicates whether parking is available at the location.
    public var parkingAvailable: Bool?

    /// Indicates whether valet parking services are offered.
    public var valetParking: Bool?

    /// Indicates the availability of street parking near the location.
    public var streetParking: Bool?

    /// Indicates whether breakfast is served.
    public var servesBreakfast: Bool?

    /// Indicates whether brunch is served.
    public var servesBrunch: Bool?

    /// Indicates whether dinner is served.
    public var servesDinner: Bool?

    /// Indicates whether lunch is served.
    public var servesLunch: Bool?

    /// Indicates whether wine is served.
    public var servesWine: Bool?

    /// Indicates whether beer is served.
    public var servesBeer: Bool?

    /// Indicates whether vegan diet options are available.
    public var servesVegan: Bool?

    /// Indicates whether vegetarian diet options are available.
    public var servesVegetarian: Bool?

    /// Indicates whether takeout services are available.
    public var takeout: Bool?

    // MARK: Social Media and Contact

    /// The Facebook ID associated with the feature.
    public var facebookId: String?

    /// The fax number associated with the location.
    public var fax: String?

    /// The email address associated with the location.
    public var email: String?

    /// The Instagram handle associated with the location.
    public var instagram: String?

    /// The Twitter handle associated with the location.
    public var twitter: String?

    /// Detailed description
    public var detailedDescription: String?

    /// Parking information for POIs that represent parking facilities (e.g., parking lots, garages, street parking, etc.).
    @_spi(Experimental)
    public var parkingInfo: ParkingInfo?

    init(metadata: CoreResultMetadataProtocol) {
        self.data = metadata.data
        self.phone = metadata.phone
        self.website = metadata.website.flatMap { URL(string: $0) }
        self.reviewCount = metadata.reviewCount?.intValue
        self.averageRating = metadata.averageRating?.doubleValue
        self.rating = metadata.rating?.doubleValue
        self.openHours = metadata.openHours.flatMap(OpenHours.init)
        self.detailedDescription = metadata.description

        if let primaries = metadata.primaryImage, !primaries.isEmpty {
            self.primaryImage = Image(sizes: primaries.map(Image.SizedImage.init))
        }

        if let others = metadata.otherImage, !others.isEmpty {
            self.otherImages = [
                Image(sizes: others.map(Image.SizedImage.init)),
            ]
        }

        self.children = metadata.children?.compactMap { ResultChildMetadata(resultChildMetadata: $0) }

        self.description = metadata.description
        self.priceLevel = metadata.priceLevel
        self.popularity = metadata.popularity?.floatValue
        self.wheelchairAccessible = metadata.wheelchairAccessible
        self.delivery = metadata.delivery
        self.driveThrough = metadata.driveThrough
        self.reservable = metadata.reservable
        self.parkingAvailable = metadata.parkingAvailable
        self.valetParking = metadata.valetParking
        self.streetParking = metadata.streetParking
        self.servesBreakfast = metadata.servesBreakfast
        self.servesBrunch = metadata.servesBrunch
        self.servesDinner = metadata.servesDinner
        self.servesLunch = metadata.servesLunch
        self.servesWine = metadata.servesWine
        self.servesBeer = metadata.servesBeer
        self.servesVegan = metadata.servesVegan
        self.servesVegetarian = metadata.servesVegetarian
        self.takeout = metadata.takeout
        self.facebookId = metadata.facebookId
        self.fax = metadata.fax
        self.email = metadata.email
        self.instagram = metadata.instagram
        self.twitter = metadata.twitter
        self.parkingInfo = metadata.parkingInfo?.parkingInfo
    }

    public init(
        data: [String: String],
        primaryImage: Image?,
        otherImages: [Image]?,
        phone: String?,
        website: URL?,
        reviewCount: Int?,
        averageRating: Double?,
        openHours: OpenHours?,
        detailedDescription: String? = nil
    ) {
        self.data = data
        self.primaryImage = primaryImage
        self.otherImages = otherImages
        self.phone = phone
        self.website = website
        self.reviewCount = reviewCount
        self.averageRating = averageRating
        self.openHours = openHours
        self.description = nil
        self.detailedDescription = detailedDescription
    }

    /// Please use rating instead
    public init(
        data: [String: String],
        primaryImage: Image?,
        otherImages: [Image]?,
        phone: String?,
        website: URL?,
        reviewCount: Int?,
        averageRating: Double?,
        openHours: OpenHours?,
        children: [ResultChildMetadata]? = nil,
        description: String? = nil,
        priceLevel: String? = nil,
        popularity: Float? = nil,
        wheelchairAccessible: Bool? = nil,
        delivery: Bool? = nil,
        driveThrough: Bool? = nil,
        reservable: Bool? = nil,
        parkingAvailable: Bool? = nil,
        valetParking: Bool? = nil,
        streetParking: Bool? = nil,
        servesBreakfast: Bool? = nil,
        servesBrunch: Bool? = nil,
        servesDinner: Bool? = nil,
        servesLunch: Bool? = nil,
        servesWine: Bool? = nil,
        servesBeer: Bool? = nil,
        servesVegan: Bool? = nil,
        servesVegetarian: Bool? = nil,
        takeout: Bool? = nil,
        facebookId: String? = nil,
        fax: String? = nil,
        email: String? = nil,
        instagram: String? = nil,
        twitter: String? = nil
    ) {
        self.data = data
        self.primaryImage = primaryImage
        self.otherImages = otherImages
        self.phone = phone
        self.website = website
        self.reviewCount = reviewCount
        self.averageRating = averageRating
        self.openHours = openHours

        self.children = children
        self.description = description
        self.priceLevel = priceLevel
        self.popularity = popularity
        self.wheelchairAccessible = wheelchairAccessible
        self.delivery = delivery
        self.driveThrough = driveThrough
        self.reservable = reservable
        self.parkingAvailable = parkingAvailable
        self.valetParking = valetParking
        self.streetParking = streetParking
        self.servesBreakfast = servesBreakfast
        self.servesBrunch = servesBrunch
        self.servesDinner = servesDinner
        self.servesLunch = servesLunch
        self.servesWine = servesWine
        self.servesBeer = servesBeer
        self.servesVegan = servesVegan
        self.servesVegetarian = servesVegetarian
        self.takeout = takeout
        self.facebookId = facebookId
        self.fax = fax
        self.email = email
        self.instagram = instagram
        self.twitter = twitter
    }

    public init(
        data: [String: String],
        primaryImage: Image?,
        otherImages: [Image]?,
        phone: String?,
        website: URL?,
        reviewCount: Int?,
        rating: Double?,
        openHours: OpenHours?,
        children: [ResultChildMetadata]? = nil,
        description: String? = nil,
        priceLevel: String? = nil,
        popularity: Float? = nil,
        wheelchairAccessible: Bool? = nil,
        delivery: Bool? = nil,
        driveThrough: Bool? = nil,
        reservable: Bool? = nil,
        parkingAvailable: Bool? = nil,
        valetParking: Bool? = nil,
        streetParking: Bool? = nil,
        servesBreakfast: Bool? = nil,
        servesBrunch: Bool? = nil,
        servesDinner: Bool? = nil,
        servesLunch: Bool? = nil,
        servesWine: Bool? = nil,
        servesBeer: Bool? = nil,
        servesVegan: Bool? = nil,
        servesVegetarian: Bool? = nil,
        takeout: Bool? = nil,
        facebookId: String? = nil,
        fax: String? = nil,
        email: String? = nil,
        instagram: String? = nil,
        twitter: String? = nil
    ) {
        self.data = data
        self.primaryImage = primaryImage
        self.otherImages = otherImages
        self.phone = phone
        self.website = website
        self.reviewCount = reviewCount
        self.rating = rating
        self.openHours = openHours

        self.children = children
        self.description = description
        self.priceLevel = priceLevel
        self.popularity = popularity
        self.wheelchairAccessible = wheelchairAccessible
        self.delivery = delivery
        self.driveThrough = driveThrough
        self.reservable = reservable
        self.parkingAvailable = parkingAvailable
        self.valetParking = valetParking
        self.streetParking = streetParking
        self.servesBreakfast = servesBreakfast
        self.servesBrunch = servesBrunch
        self.servesDinner = servesDinner
        self.servesLunch = servesLunch
        self.servesWine = servesWine
        self.servesBeer = servesBeer
        self.servesVegan = servesVegan
        self.servesVegetarian = servesVegetarian
        self.takeout = takeout
        self.facebookId = facebookId
        self.fax = fax
        self.email = email
        self.instagram = instagram
        self.twitter = twitter
    }

    /// Access to the raw metadata strings
    public subscript(key: String) -> String? {
        data[key]
    }
}
