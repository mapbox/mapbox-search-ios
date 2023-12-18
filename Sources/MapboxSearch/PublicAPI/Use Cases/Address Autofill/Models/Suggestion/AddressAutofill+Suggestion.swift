// Copyright © 2022 Mapbox. All rights reserved.

import Foundation
import CoreLocation

public extension AddressAutofill {
    struct Suggestion {
        /// Suggestion name.
        public let name: String
        
        /// Textual representation of the address.
        public let formattedAddress: String
        
        /// Address geographic point. May be nil.
        public let coordinate: CLLocationCoordinate2D?

        /// The individual address components.
        internal let addressComponents: NonEmptyArray<AddressComponent>

        /// THe original search's request, used to complete autofill/v1/retrieve calls for this suggestion.
        internal let coreSearch: CoreSearchResultProtocol?

        /// The original search's options, used to complete autofill/v1/retrieve calls for this suggestion.
        internal let coreRequestOptions: CoreRequestOptions?

        init(
            name: String,
            formattedAddress: String,
            coordinate: CLLocationCoordinate2D?,
            addressComponents: NonEmptyArray<AddressComponent>,
            coreSearch: CoreSearchResultProtocol? = nil,
            coreRequestOptions: CoreRequestOptions? = nil
        ) {
            self.name = name
            self.formattedAddress = formattedAddress
            self.coordinate = coordinate
            self.addressComponents = addressComponents
            self.coreSearch = coreSearch
            self.coreRequestOptions = coreRequestOptions
        }
    }
}
