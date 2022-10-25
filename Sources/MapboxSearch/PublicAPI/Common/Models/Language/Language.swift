// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

public struct Language: Equatable {
    public let languageCode: String
    
    /// Language model initializier
    /// - Parameter languageCode: Permitted values are ISO 639-1 language codes
    public init?(languageCode: String) {
        guard let isoCode = ISO639_1(rawValue: languageCode.lowercased()) else {
            return nil
        }
        
        self.languageCode = isoCode.rawValue
    }
    
    /// Language model initializier
    /// - Parameter locale: only `languageCode` component is used if exist.
    public init?(locale: Locale) {
        guard let isoCode = locale.languageCode.flatMap(ISO639_1.init(rawValue:)) else {
            return nil
        }
        
        self.languageCode = isoCode.rawValue
    }
    
    static var `default`: Self {
        Language(languageCode: "en")!
    }
}
