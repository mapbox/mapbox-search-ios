import Foundation

protocol CoreResultMetadataProtocol {
    var data: [String: String] { get }

    var primaryImage: [CoreImageInfoProtocol]? { get }
    var otherImage: [CoreImageInfoProtocol]? { get }

    var description: String? { get }

    var averageRating: NSNumber? { get }
    var reviewCount: NSNumber? { get }

    var phone: String? { get }
    var website: String? { get }

    var openHours: CoreOpenHours? { get }
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
}
