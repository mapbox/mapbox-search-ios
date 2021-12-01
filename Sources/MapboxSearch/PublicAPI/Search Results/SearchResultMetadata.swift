import Foundation
import CoreGraphics

/// SearchResult additional information, such as phone, website and etc.
/// Extra metadata contained in data field as dictionary.
public struct SearchResultMetadata: Codable, Hashable {
    
    /// SearchResultMetadata Image information. Contains width, height and image url
    public struct SizedImage: Codable, Hashable {
        /// Image source URL
        public var url: URL?
        
        /// Image sizes
        public var size: CGSize
        
        init(coreImageInfo: CoreImageInfoProtocol) {
            self.size = CGSize(width: CGFloat(coreImageInfo.width), height: CGFloat(coreImageInfo.height))
            self.url = URL(string: coreImageInfo.url)
            assert(self.url != nil, "Invalid Image URL string")
        }
        
        /// Hash implementation for ``SearchResultMetadata/SizedImage``
        /// - Parameter hasher: system hasher
        public func hash(into hasher: inout Hasher) {
            hasher.combine(url?.hashValue)
            hasher.combine(size.width.hashValue)
            hasher.combine(size.height.hashValue)
        }
    }
    
    /// SearchResultMetadata Image collection. Contains array of image urls for different sizes.
    public struct Image: Codable, Hashable {
        var sizes: [SizedImage]
        
        init?(sizes: [SizedImage]) {
            guard sizes.isEmpty == false else {
                return nil
            }
            self.sizes = sizes
        }
    }
    
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
        self.website = metadata.website.flatMap({ URL(string: $0) })
        self.reviewCount = metadata.reviewCount?.intValue
        self.averageRating = metadata.averageRating?.doubleValue
        self.openHours = metadata.openHours.flatMap(OpenHours.init)
        
        if let primaries = metadata.primaryImage {
            self.primaryImage = Image(sizes: primaries.map(SizedImage.init))
        }
        if let others = metadata.otherImage, let image = Image(sizes: others.map(SizedImage.init)) {
            self.otherImages = [image]
        }
    }
    
    /// Access to the raw metadata strings
    public subscript(key: String) -> String? {
        data[key]
    }
}
