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
    var wheelchairAccessible: Bool? { get }

    /** Indicates whether the location offers delivery services. */
    var delivery: Bool? { get }

    /** Indicates whether the location has a drive-through service. */
    var driveThrough: Bool? { get }

    /** Indicates whether the location accepts reservations. */
    var reservable: Bool? { get }

    /** Indicates whether parking is available at the location. */
    var parkingAvailable: Bool? { get }

    /** Indicates whether valet parking services are offered. */
    var valetParking: Bool? { get }

    /** Indicates the availability of street parking near the location. */
    var streetParking: Bool? { get }

    /** Indicates whether breakfast is served. */
    var servesBreakfast: Bool? { get }

    /** Indicates whether brunch is served. */
    var servesBrunch: Bool? { get }

    /** Indicates whether dinner is served. */
    var servesDinner: Bool? { get }

    /** Indicates whether lunch is served. */
    var servesLunch: Bool? { get }

    /** Indicates whether wine is served. */
    var servesWine: Bool? { get }

    /** Indicates whether beer is served. */
    var servesBeer: Bool? { get }

    /** Indicates whether vegan diet options are available. */
    var servesVegan: Bool? { get }

    /** Indicates whether vegetarian diet options are available. */
    var servesVegetarian: Bool? { get }

    /** Indicates whether takeout services are available. */
    var takeout: Bool? { get }

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

    // MARK: Characteristics and Options Implementation

    var wheelchairAccessible: Bool? {
        __wheelchairAccessible?.boolValue
    }

    var delivery: Bool? {
        __delivery?.boolValue
    }

    var driveThrough: Bool? {
        __driveThrough?.boolValue
    }

    var reservable: Bool? {
        __reservable?.boolValue
    }

    var parkingAvailable: Bool? {
        __parkingAvailable?.boolValue
    }

    var valetParking: Bool? {
        __valetParking?.boolValue
    }

    var streetParking: Bool? {
        __streetParking?.boolValue
    }

    var servesBreakfast: Bool? {
        __servesBreakfast?.boolValue
    }

    var servesBrunch: Bool? {
        __servesBrunch?.boolValue
    }

    var servesDinner: Bool? {
        __servesDinner?.boolValue
    }

    var servesLunch: Bool? {
        __servesLunch?.boolValue
    }

    var servesWine: Bool? {
        __servesWine?.boolValue
    }

    var servesBeer: Bool? {
        __servesBeer?.boolValue
    }

    var servesVegan: Bool? {
        __servesVegan?.boolValue
    }

    var servesVegetarian: Bool? {
        __servesVegetarian?.boolValue
    }

    var takeout: Bool? {
        __takeout?.boolValue
    }
}
