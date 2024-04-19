import CoreLocation
import Foundation

extension AddressAutofill {
    public struct Suggestion {
        /// Suggestion name.
        public let name: String

        /// A unique identifier for the geographic feature
        public let mapboxId: String?

        /// Textual representation of the address.
        public let formattedAddress: String

        /// Address geographic point. May be nil.
        public let coordinate: CLLocationCoordinate2D?

        /// The individual address components.
        let addressComponents: NonEmptyArray<AddressComponent>

        /// Underlying data provided by core SDK and API used to construct this Suggestion instance.
        /// Useful for any follow-up API calls or unit test validation.
        let underlying: Underlying

        init(
            name: String,
            mapboxId: String?,
            formattedAddress: String,
            coordinate: CLLocationCoordinate2D?,
            addressComponents: NonEmptyArray<AddressComponent>,
            underlying: Underlying
        ) {
            self.name = name
            self.mapboxId = mapboxId
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
