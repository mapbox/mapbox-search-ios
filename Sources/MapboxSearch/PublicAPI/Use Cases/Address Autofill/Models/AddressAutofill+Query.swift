// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

public extension AddressAutofill {
    struct Query {
        public enum Requirements {
            static let queryLength: UInt = 3
        }
                
        /// Identifies search query.
        public let value: String
                
        /// Query initializer
        /// - Parameters:
        ///   - query: query string which should satisfy all requirements defined in `Requirements` type.
        public init?(value: String) {
            guard value.count >= Requirements.queryLength else { return nil }
                    
            self.value = value
        }
    }
}
