import CoreGraphics
import Foundation

/// SearchResult additional information, such as phone, website and etc.
/// Extra metadata contained in data field as dictionary.
public struct SearchResultMetadata: Codable, Hashable {
    /// Metadata extra data.
    public var data: [String: String]

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

    /// Average rating
    public var averageRating: Double?

    /// Business opening hours
    public var openHours: OpenHours?

    init(metadata: CoreResultMetadataProtocol) {
        self.data = metadata.data
        self.phone = metadata.phone
        self.website = metadata.website.flatMap { URL(string: $0) }
        self.reviewCount = metadata.reviewCount?.intValue
        self.averageRating = metadata.averageRating?.doubleValue
        self.openHours = metadata.openHours.flatMap(OpenHours.init)

        if let primaries = metadata.primaryImage, !primaries.isEmpty {
            self.primaryImage = Image(sizes: primaries.map(Image.SizedImage.init))
        }

        if let others = metadata.otherImage, !others.isEmpty {
            self.otherImages = [
                Image(sizes: others.map(Image.SizedImage.init)),
            ]
        }
    }

    /// Access to the raw metadata strings
    public subscript(key: String) -> String? {
        data[key]
    }
}
