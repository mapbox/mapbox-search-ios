import CoreLocation
@testable import MapboxSearch
import XCTest

extension CoreSearchResultStub {
    static let sample1 = CoreSearchResultStub(
        id: "sample-1",
        mapboxId: nil,
        type: .poi,
        distance: 4200,
        estimatedTime: Measurement(value: 10.5, unit: .minutes)
    )
    static let sample2 = CoreSearchResultStub(
        id: "sample-2",
        mapboxId: nil,
        type: .category
    )

    static let externalRecordSample = CoreSearchResultStub(
        id: "sample-3",
        mapboxId: nil,
        type: .userRecord,
        center: .sample1,
        layer: FavoritesProvider.providerIdentifier,
        userRecordID: "external-record-1",
        action: .sample1,
        serverIndex: 3,
        distance: 97
    )

    static func makeSuggestionsSet() -> [CoreSearchResultStub] {
        let results = makeMixedResultsSet()
        results.forEach { $0.center = nil }
        return results
    }

    static func makeSuggestion(metadata: CoreResultMetadata? = nil) -> CoreSearchResultStub {
        let result = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .place,
            names: ["Some Place Name"],
            languages: ["en"],
            center: nil,
            categories: ["cafe"],
            icon: Maki.alcoholShop.name,
            metadata: metadata
        )
        return result
    }

    static func makeMixedResultsSet() -> [CoreSearchResultStub] {
        [
            CoreSearchResultStub.makePlace(),
            CoreSearchResultStub.makeAddress(),
            CoreSearchResultStub.makePOI(),
            CoreSearchResultStub.makeFavorite(),
            CoreSearchResultStub.makeHistory(),
        ]
    }

    static func makeCategoryResultsSet() -> [CoreSearchResultStub] {
        [
            CoreSearchResultStub.makePlace(),
            CoreSearchResultStub.makeAddress(),
            CoreSearchResultStub.makePOI(),
        ]
    }

    static func makeSuggestionTypeQuery() -> CoreSearchResultStub {
        CoreSearchResultStub(id: "recursion", mapboxId: nil, type: .query, center: nil)
    }

    static func makeCategory() -> CoreSearchResultStub {
        CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .category,
            names: ["Bar"],
            languages: ["en"],
            categories: ["cafe"],
            icon: Maki.cafe.name
        )
    }

    static func makePlace() -> CoreSearchResultStub {
        let center = CLLocation(latitude: 12.0000, longitude: 10.0000)
        let result = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .place,
            names: ["Some Place Name"],
            languages: ["en"],
            center: center,
            categories: ["cafe"],
            icon: Maki.alcoholShop.name
        )
        return result
    }

    static func makeAddress() -> CoreSearchResultStub {
        let result = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .address,
            names: ["Some Place Name"],
            languages: ["en"],
            center: .sample1,
            categories: ["address", "location"],
            icon: Maki.alcoholShop.name
        )
        return result
    }

    static func makePOI() -> CoreSearchResultStub {
        let center = CLLocation(latitude: 12.0000, longitude: 10.0000)
        let address = CoreAddress(
            houseNumber: "55",
            street: "some POI street",
            neighborhood: nil,
            locality: nil,
            postcode: nil,
            place: nil,
            district: "poi-land",
            region: CoreSearchAddressRegion(
                name: "poi-region",
                regionCode: nil,
                regionCodeFull: nil
            ),
            country: CoreSearchAddressCountry(
                name: "poi-country",
                countryCode: nil,
                countryCodeAlpha3: nil
            )
        )
        let result = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .place,
            names: ["Some Place Name"],
            languages: ["en"],
            addresses: [address],
            center: center,
            categories: ["poi"],
            icon: Maki.viewpoint.name
        )
        return result
    }

    static func makeFavorite() -> CoreSearchResultStub {
        let center = CLLocation(latitude: 12.0000, longitude: 10.0000)
        let address = CoreAddress(
            houseNumber: "5",
            street: "some Favorite street",
            neighborhood: nil,
            locality: nil,
            postcode: nil,
            place: nil,
            district: "pizza-land",
            region: CoreSearchAddressRegion(
                name: "pizza-region",
                regionCode: nil,
                regionCodeFull: nil
            ),
            country: CoreSearchAddressCountry(
                name: "pizza-country",
                countryCode: nil,
                countryCodeAlpha3: nil
            )
        )
        let result = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .place,
            names: ["Some Place Name"],
            languages: ["en"],
            addresses: [address],
            center: center,
            categories: ["pizza", "cafe"],
            icon: Maki.fastFood.name
        )
        return result
    }

    static func makeHistory() -> CoreSearchResultStub {
        let center = CLLocation(latitude: 12.0000, longitude: 10.0000)
        let address = CoreAddress(
            houseNumber: "15",
            street: "history street",
            neighborhood: nil,
            locality: nil,
            postcode: nil,
            place: nil,
            district: "history-land",
            region: CoreSearchAddressRegion(
                name: "history-region",
                regionCode: nil,
                regionCodeFull: nil
            ),
            country: CoreSearchAddressCountry(
                name: "history-country",
                countryCode: nil,
                countryCodeAlpha3: nil
            )
        )
        let result = CoreSearchResultStub(
            id: UUID().uuidString,
            mapboxId: nil,
            type: .place,
            names: ["Some Place Name"],
            languages: ["en"],
            addresses: [address],
            center: center,
            categories: ["history", "other"],
            icon: Maki.fastFood.name
        )
        return result
    }
}
