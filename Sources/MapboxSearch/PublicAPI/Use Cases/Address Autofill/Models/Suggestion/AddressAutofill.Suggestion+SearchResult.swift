import CoreLocation
import Foundation

extension AddressAutofill.Suggestion {
    enum Error: Swift.Error {
        case emptyAddress
        case incorrectFormattedAddress
        case invalidCoordinates
    }

    static func from(_ searchResult: SearchResult) throws -> Self {
        guard let address = searchResult.address else {
            throw Error.emptyAddress
        }

        guard let formattedAddress = address.formattedAddress(style: .full) else {
            throw Error.incorrectFormattedAddress
        }

        guard CLLocationCoordinate2DIsValid(searchResult.coordinate) else {
            throw Error.invalidCoordinates
        }

        return try .init(
            name: searchResult.name,
            mapboxId: searchResult.mapboxId,
            formattedAddress: formattedAddress,
            coordinate: searchResult.coordinate,
            addressComponents: address.toAutofillComponents(),
            underlying: .result(searchResult)
        )
    }
}

// MARK: - Internal

extension Address {
    enum AutofillParsingError: Error {
        case emptyAddressComponents
    }

    func toAutofillComponents() throws -> NonEmptyArray<AddressAutofill.AddressComponent> {
        var components: [AddressAutofill.AddressComponent] = []

        houseNumber.map { components.append(.init(kind: .houseNumber, value: $0)) }
        street.map { components.append(.init(kind: .street, value: $0)) }
        neighborhood.map { components.append(.init(kind: .neighborhood, value: $0)) }
        locality.map { components.append(.init(kind: .locality, value: $0)) }
        postcode.map { components.append(.init(kind: .postcode, value: $0)) }
        place.map { components.append(.init(kind: .place, value: $0)) }
        district.map { components.append(.init(kind: .district, value: $0)) }
        region.map { components.append(.init(kind: .region, value: $0)) }
        country.map { components.append(.init(kind: .country, value: $0)) }

        guard let first = components.first else {
            throw AutofillParsingError.emptyAddressComponents
        }

        return .init(
            first: first,
            others: Array(components.dropFirst())
        )
    }
}
