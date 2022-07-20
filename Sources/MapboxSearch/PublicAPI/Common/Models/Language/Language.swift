// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

public struct Language: Equatable {
    public let languageCode: String
    
    /// Country model initializier
    /// - Parameter languageCode: Permitted values are ISO 639-1 language codes
    public init?(languageCode: String) {
        guard let isoCode = ISO639_1(rawValue: languageCode.lowercased()) else {
            return nil
        }
        
        self.languageCode = isoCode.rawValue
    }
    
    static var `default`: Self {
        Language(languageCode: "en")!
    }
}
