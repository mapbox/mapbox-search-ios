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

        /// Underlying data provided by core SDK and API used to construct this Suggestion instance.
        /// Useful for any follow-up API calls or unit test validation.
        internal let underlying: Underlying

        init(
            name: String,
            formattedAddress: String,
            coordinate: CLLocationCoordinate2D?,
            addressComponents: NonEmptyArray<AddressComponent>,
            underlying: Underlying
        ) {
            self.name = name
            self.formattedAddress = formattedAddress
            self.coordinate = coordinate
            self.addressComponents = addressComponents
            self.underlying = underlying
        }
    }
}

extension AddressAutofill.Suggestion {
    enum Underlying {
        case suggestion(CoreSearchResultProtocol, CoreRequestOptions)
        case result(SearchResult)
    }
}
