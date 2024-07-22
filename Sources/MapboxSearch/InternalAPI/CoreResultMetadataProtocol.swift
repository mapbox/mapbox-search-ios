import Foundation

protocol CoreResultMetadataProtocol {
    // MARK: Basic metadata

    /** Dictionary with other metadata like "iso\_3166\_1" and "iso\_3166\_2" codes. */
    var data: [String: String] { get }

    /** Child metadata for a POI */
    var children: [CoreResultChildMetadata]? { get }

    /** Primary photos array. */
    var primaryImage: [CoreImageInfoProtocol]? { get }

    /** Secondary photos array. */
    var otherImage: [CoreImageInfoProtocol]? { get }

    /** Long form detailed description for POI. */
    var description: String? { get }

    /** The average rating of the location, on a scale from 1 to 5. */
    var averageRating: NSNumber? { get }

    /** The number of reviews for this result. */
    var reviewCount: NSNumber? { get }

    /** Phone number. */
    var phone: String? { get }

    /** The website URL associated with the location. */
    var website: String? { get }

    // MARK: Characteristics and Options

    /** The price level of the location, represented by a string including dollar signs. The values scale from Cheap "$" to Most Expensive "$$$$". */
    var priceLevel: String? { get }

    /** A popularity score for the location, calculated based on user engagement and review counts. The value scales from 0 to 1, 1 being the most popular. */
    var popularity: NSNumber? { get }

    /** POI open hours */
    var openHours: CoreOpenHours? { get }

    /** Parking information for POIs. */
    var parkingData: CoreParkingData? { get }

    /** Indicates whether the location is accessible by wheelchair. */
    var wheelchairAccessible: NSNumber? { get }

    /** Indicates whether the location offers delivery services. */
    var delivery: NSNumber? { get }

    /** Indicates whether the location has a drive-through service. */
    var driveThrough: NSNumber? { get }

    /** Indicates whether the location accepts reservations. */
    var reservable: NSNumber? { get }

    /** Indicates whether parking is available at the location. */
    var parkingAvailable: NSNumber? { get }

    /** Indicates whether valet parking services are offered. */
    var valetParking: NSNumber? { get }

    /** Indicates the availability of street parking near the location. */
    var streetParking: NSNumber? { get }

    /** Indicates whether breakfast is served. */
    var servesBreakfast: NSNumber? { get }

    /** Indicates whether brunch is served. */
    var servesBrunch: NSNumber? { get }

    /** Indicates whether dinner is served. */
    var servesDinner: NSNumber? { get }

    /** Indicates whether lunch is served. */
    var servesLunch: NSNumber? { get }

    /** Indicates whether wine is served. */
    var servesWine: NSNumber? { get }

    /** Indicates whether beer is served. */
    var servesBeer: NSNumber? { get }

    /** Indicates whether vegan diet options are available. */
    var servesVegan: NSNumber? { get }

    /** Indicates whether vegetarian diet options are available. */
    var servesVegetarian: NSNumber? { get }

    /** Indicates whether takeout services are available. */
    var takeout: NSNumber? { get }

    // MARK: Social Media and Contact

    /** The Facebook ID associated with the feature. */
    var facebookId: String? { get }

    /** The fax number associated with the location. */
    var fax: String? { get }

    /** The email address associated with the location. */
    var email: String? { get }

    /** The Instagram handle associated with the location. */
    var instagram: String? { get }

    /** The Twitter handle associated with the location. */
    var twitter: String? { get }
}

extension CoreResultMetadata: CoreResultMetadataProtocol {
    var primaryImage: [CoreImageInfoProtocol]? {
        primaryPhoto
    }

    var otherImage: [CoreImageInfoProtocol]? {
        otherPhoto
    }

    var averageRating: NSNumber? {
        avRating
    }

    var parkingData: CoreParkingData? {
        parking
    }
}
