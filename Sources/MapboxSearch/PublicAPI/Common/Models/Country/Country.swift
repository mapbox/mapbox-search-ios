// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

public struct Country: Equatable {
    public let countryCode: String
    
    /// Country model initializier
    /// - Parameter countryCode: Permitted values are ISO 3166-1 alpha 2 country codes (e.g. US, DE, GB)
    public init?(countryCode: String) {
        guard ISO3166_1_alpha1(rawValue: countryCode.uppercased()) != nil else {
            return nil
        }
        
        self.countryCode = countryCode.lowercased()
    }
}
