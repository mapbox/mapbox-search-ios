@testable import MapboxSearch
import CoreLocation


class SearchResultStub: SearchResult {
    init(
        id: String,
        accuracy: SearchResultAccuracy? = nil,
        categories: [String]? = nil,
        name: String,
        matchingName: String?,
        serverIndex: Int?,
        iconName: String? = nil,
        resultType: SearchResultType,
        routablePoints: [RoutablePoint]? = nil,
        coordinate: CLLocationCoordinate2DCodable,
        address: Address? = nil,
        metadata: SearchResultMetadata?,
        searchRequest: SearchRequestOptions = .init(query: "Sample", proximity: nil),
        dataLayerIdentifier: String = "unit-test-stub"
    ) {
        self.id = id
        self.accuracy = accuracy
        self.categories = categories
        self.name = name
        self.matchingName = matchingName
        self.serverIndex = serverIndex
        self.iconName = iconName
        self.type = resultType
        self.routablePoints = routablePoints
        self.coordinateCodable = coordinate
        self.address = address
        self.metadata = metadata
        self.dataLayerIdentifier = dataLayerIdentifier
        self.searchRequest = searchRequest
    }
    
    var dataLayerIdentifier: String
    
    var id: String
    var accuracy: SearchResultAccuracy?
    var categories: [String]?
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
    var address: Address?
    var descriptionText: String?
    var searchRequest: SearchRequestOptions
}
