// Copyright © 2022 Mapbox. All rights reserved.

import Foundation
import CoreGraphics

/// SearchResultMetadata Image collection. Contains array of image urls for different sizes.
public struct Image: Codable, Hashable {
    public let sizes: [SizedImage]
    
    init(sizes: [SizedImage]) {
        self.sizes = sizes
    }
}

public extension Image {
    /// SearchResultMetadata Image information. Contains width, height and image url
    struct SizedImage: Codable, Hashable {
        /// Image source URL
        public var url: URL?
        
        /// Image sizes
        public var size: CGSize
        
        init(coreImageInfo: CoreImageInfoProtocol) {
            self.size = CGSize(width: CGFloat(coreImageInfo.width), height: CGFloat(coreImageInfo.height))
            self.url = URL(string: coreImageInfo.url)
            assert(self.url != nil, "Invalid Image URL string")
        }
        
        /// Hash implementation for ``Image/SizedImage``
        /// - Parameter hasher: system hasher
        public func hash(into hasher: inout Hasher) {
            hasher.combine(url?.hashValue)
            hasher.combine(size.width.hashValue)
            hasher.combine(size.height.hashValue)
        }
    }
}
