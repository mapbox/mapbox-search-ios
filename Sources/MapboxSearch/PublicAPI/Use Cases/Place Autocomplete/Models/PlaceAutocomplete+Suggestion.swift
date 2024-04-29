import CoreLocation
import Foundation

extension PlaceAutocomplete {
    public struct Suggestion {
        /// Place's name.
        public let name: String

        /// A unique identifier for the geographic feature
        public let mapboxId: String?

        /// Contains formatted address.
        public let description: String?

        /// Geographic point.
        public let coordinate: CLLocationCoordinate2D?

        /// Icon name according to [Mapbox Maki icon set](https://github.com/mapbox/maki/)
        public let iconName: String?

        /// The straight line distance in meters between the origin and this suggestion.
        public let distance: CLLocationDistance?

        /// Estimated time of arrival (in minutes) based on specified `proximity`.
        public let estimatedTime: Measurement<UnitDuration>?

        /// The type of result.
        public let placeType: SearchResultType

        /// Poi categories. Always empty for non-POI suggestions.
        public let categories: [String]

        /// List of points near `coordinate`, that represents entries to associated building.
        public let routablePoints: [RoutablePoint]

        /// Underlying data provided by core SDK and API used to construct this Suggestion instance.
        /// Useful for any follow-up API calls or unit test validation.
        let underlying: Underlying

        init(
            name: String,
            mapboxId: String?,
            description: String?,
            coordinate: CLLocationCoordinate2D?,
            iconName: String?,
            distance: CLLocationDistance?,
            estimatedTime: Measurement<UnitDuration>?,
            placeType: SearchResultType,
            categories: [String],
            routablePoints: [RoutablePoint],
            underlying: Underlying
        ) {
            self.name = name
            self.mapboxId = mapboxId
            self.description = description
            self.coordinate = coordinate
            self.iconName = iconName
            self.distance = distance
            self.estimatedTime = estimatedTime
            self.placeType = placeType
            self.categories = categories
            self.routablePoints = routablePoints
            self.underlying = underlying
        }
    }
}

extension PlaceAutocomplete.Suggestion {
    enum Underlying {
        case suggestion(CoreSearchResultProtocol, CoreRequestOptions)
        case result(SearchResult)
    }

    func result(for underlyingResult: SearchResult) -> PlaceAutocomplete.Result {
        .init(
            name: name,
            mapboxId: underlyingResult.mapboxId,
            description: description,
            type: placeType,
            coordinate: coordinate,
            iconName: iconName,
            distance: distance,
            estimatedTime: estimatedTime,
            routablePoints: underlyingResult.routablePoints ?? [],
            categories: underlyingResult.categories ?? [],
            address: AddressComponents(searchResult: underlyingResult),
            phone: underlyingResult.metadata?.phone,
            website: underlyingResult.metadata?.website,
            reviewCount: underlyingResult.metadata?.reviewCount,
            averageRating: underlyingResult.metadata?.averageRating,
            openHours: underlyingResult.metadata?.openHours,
            primaryImage: underlyingResult.metadata?.primaryImage,
            otherImages: underlyingResult.metadata?.otherImages
        )
    }
}

// MARK: - Mapping

extension PlaceAutocomplete.Suggestion {
    enum Error: Swift.Error {
        case invalidCoordinates
        case invalidResultType
    }

    static func from(_ searchResult: SearchResult) throws -> Self {
        guard let searchResultType = searchResult as? ServerSearchResult else {
            throw Error.invalidResultType
        }

        guard CLLocationCoordinate2DIsValid(searchResult.coordinate) else {
            throw Error.invalidCoordinates
        }

        return .init(
            name: searchResult.name,
            mapboxId: searchResult.mapboxId,
            description: searchResult.descriptionText,
            coordinate: searchResult.coordinate,
            iconName: searchResult.iconName,
            distance: searchResultType.distance,
            estimatedTime: searchResultType.estimatedTime,
            placeType: searchResultType.type,
            categories: searchResultType.categories ?? [],
            routablePoints: searchResultType.routablePoints ?? [],
            underlying: .result(searchResult)
        )
    }

    static func from(
        searchSuggestion: CoreSearchResultProtocol,
        options: CoreRequestOptions
    ) throws -> Self {
        guard let type = SearchResultType(coreResultTypes: searchSuggestion.resultTypes) else {
            throw Error.invalidResultType
        }

        guard let coordinate = searchSuggestion.center?.coordinate,
              CLLocationCoordinate2DIsValid(coordinate)
        else {
            throw Error.invalidCoordinates
        }

        return .init(
            name: searchSuggestion.names.first ?? "",
            mapboxId: searchSuggestion.mapboxId,
            description: searchSuggestion.addressDescription,
            coordinate: coordinate,
            iconName: searchSuggestion.icon,
            distance: searchSuggestion.distanceToProximity,
            estimatedTime: searchSuggestion.estimatedTime,
            placeType: type,
            categories: searchSuggestion.categories ?? [],
            routablePoints: searchSuggestion.routablePoints?.map(RoutablePoint.init) ?? [],
            underlying: .suggestion(searchSuggestion, options)
        )
    }
}
