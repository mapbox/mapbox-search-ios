import CoreLocation
@testable import MapboxSearch

struct IndexableRecordStub: IndexableRecord {
    var id: String
    var name: String
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
    var additionalTokens: Set<String>?
    var descriptionText: String?
    var routablePoints: [RoutablePoint]?
    var categories: [String]?
    var makiIcon: String?
    var metadata: SearchResultMetadata?
    var type: SearchResultType

    var asResolved: SearchResult {
        SearchResultStub(
            id: id,
            mapboxId: nil,
            categories: nil,
            name: name,
            matchingName: nil,
            serverIndex: nil,
            iconName: nil,
            resultType: .address(subtypes: [.address]),
            coordinate: .init(coordinate),
            distance: nil,
            address: address,
            metadata: nil
        )
    }

    init(
        id: String,
        name: String,
        coordinate: CLLocationCoordinate2DCodable,
        address: Address? = nil,
        additionalTokens: Set<String>? = nil,
        type: SearchResultType = .POI
    ) {
        self.id = id
        self.name = name
        self.coordinateCodable = coordinate
        self.address = address
        self.additionalTokens = additionalTokens
        self.type = type
    }

    init() {
        self.init(
            id: UUID().uuidString,
            name: UUID().uuidString,
            coordinate: .sample1,
            address: .fullAddress,
            additionalTokens: ["unit-test", "unit test", "tests"]
        )
    }
}
