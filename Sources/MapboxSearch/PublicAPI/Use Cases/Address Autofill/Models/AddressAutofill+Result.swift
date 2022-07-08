// Copyright © 2022 Mapbox. All rights reserved.

import Foundation

public extension AddressAutofill {
    struct Result {
        /// [AddressAutofillSuggestion] from which this result has been resolved.
        public let suggestion: Suggestion
        
        // Detailed address components like street, house number, etc.
        public let addressComponents: NonEmptyArray<AddressComponent>
        
        init(suggestion: Suggestion, addressComponents: NonEmptyArray<AddressComponent>) {
            self.suggestion = suggestion
            self.addressComponents = addressComponents
        }
    }
}
