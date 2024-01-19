import Foundation

extension AddressAutofill {
    public struct Result {
        /// Result name.
        public let name: String

        /// Textual representation of the address.
        public let formattedAddress: String

        /// Address geographic point.
        public let coordinate: CLLocationCoordinate2D

        /// Detailed address components like street, house number, etc.
        public let addressComponents: NonEmptyArray<AddressComponent>

        init(
            name: String,
            formattedAddress: String,
            coordinate: CLLocationCoordinate2D,
            addressComponents: NonEmptyArray<AddressComponent>
        ) {
            self.name = name
            self.formattedAddress = formattedAddress
            self.coordinate = coordinate
            self.addressComponents = addressComponents
        }
    }
}
