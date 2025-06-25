import CoreLocation
@testable import MapboxSearch

class SearchResultStub: SearchResult {
    init(
        id: String,
        mapboxId: String?,
        accuracy: SearchResultAccuracy? = nil,
        categories: [String]? = nil,
        categoryIds: [String]? = nil,
        name: String,
        matchingName: String?,
        serverIndex: Int?,
        iconName: String? = nil,
        resultType: SearchResultType,
        routablePoints: [RoutablePoint]? = nil,
        coordinate: CLLocationCoordinate2DCodable,
        distance: CLLocationDistance?,
        address: Address? = nil,
        metadata: SearchResultMetadata?,
        searchRequest: SearchRequestOptions = .init(query: "Sample", proximity: nil),
        dataLayerIdentifier: String = "unit-test-stub",
        boundingBox: BoundingBox? = .init(.init(latitude: 1.0, longitude: 2.0), .init(latitude: 2.0, longitude: 3.0))
    ) {
        self.id = id
        self.mapboxId = mapboxId
        self.accuracy = accuracy
        self.categories = categories
        self.categoryIds = categoryIds
        self.name = name
        self.matchingName = matchingName
        self.serverIndex = serverIndex
        self.iconName = iconName
        self.type = resultType
        self.routablePoints = routablePoints
        self.coordinateCodable = coordinate
        self.distance = distance
        self.address = address
        self.metadata = metadata
        self.dataLayerIdentifier = dataLayerIdentifier
        self.searchRequest = searchRequest
        self.boundingBox = boundingBox
    }

    var dataLayerIdentifier: String

    var id: String
    var mapboxId: String?
    var accuracy: SearchResultAccuracy?
    var categories: [String]?
    var categoryIds: [String]?
    var name: String
    var matchingName: String?
    var serverIndex: Int?
    var iconName: String?
    var type: SearchResultType
    var routablePoints: [RoutablePoint]?
    var estimatedTime: Measurement<UnitDuration>?
    var metadata: SearchResultMetadata?
    var coordinate: CLLocationCoordinate2D {
        get {
            coordinateCodable.coordinates
        }
        set {
            coordinateCodable = .init(newValue)
        }
    }

    var coordinateCodable: CLLocationCoordinate2DCodable
    var distance: CLLocationDistance?
    var address: Address?
    var descriptionText: String?
    var searchRequest: SearchRequestOptions
    var boundingBox: BoundingBox?
}

// MARK: - SearchResultStub

extension SearchResultStub {
    static var `default`: SearchResultStub {
        SearchResultStub(
            id: "AddressAutofillAddressComponentTests",
            mapboxId: nil,
            name: "AddressAutofillAddressComponentTests",
            matchingName: nil,
            serverIndex: nil,
            resultType: .POI,
            coordinate: .init(latitude: 12, longitude: -35),
            distance: nil,
            metadata: nil
        )
    }
}
