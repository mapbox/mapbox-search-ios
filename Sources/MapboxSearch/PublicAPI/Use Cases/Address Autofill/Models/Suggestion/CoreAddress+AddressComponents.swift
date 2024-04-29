import Foundation

extension CoreAddress {
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
        region.map { components.append(.init(kind: .region, value: $0.name)) }
        country.map { components.append(.init(kind: .country, value: $0.name)) }

        guard let first = components.first else {
            throw AutofillParsingError.emptyAddressComponents
        }

        return .init(
            first: first,
            others: Array(components.dropFirst())
        )
    }
}
