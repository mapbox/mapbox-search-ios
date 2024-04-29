import CoreLocation
@testable import MapboxSearch

class CoreSearchResultStub: CoreSearchResultProtocol {
    init(
        id: String,
        mapboxId: String?,
        resultAccuracy: CoreAccuracy? = nil,
        type: CoreResultType,
        names: [String] = ["sample-name1", "sample-name2"],
        languages: [String] = ["sample-language1", "sample-language2"],
        addresses: [CoreAddress]? = [Address.mapboxDCOffice.coreAddress()],
        addressDescription: String? = nil,
        matchingName: String? = nil,
        center: CLLocation? = .sample1,
        categories: [String]? = nil,
        routablePoints: [CoreRoutablePoint]? = nil,
        icon: String? = nil,
        layer: String? = nil,
        userRecordID: String? = nil,
        action: CoreSuggestAction? = .sample1,
        serverIndex: NSNumber? = 1,
        distance: NSNumber? = nil,
        metadata: CoreResultMetadata? = nil,
        estimatedTime: Measurement<UnitDuration>? = nil
    ) {
        self.id = id
        self.mapboxId = mapboxId
        self.resultAccuracy = resultAccuracy
        self.resultTypes = [type]
        self.names = names
        self.languages = languages
        self.addresses = addresses
        self.addressDescription = addressDescription
        self.center = center
        self.categories = categories
        self.routablePoints = routablePoints
        self.icon = icon
        self.layer = layer
        self.userRecordID = userRecordID
        self.action = action
        self.serverIndex = serverIndex
        self.distance = distance
        self.metadata = metadata
        self.estimatedTime = estimatedTime
    }

    convenience init(dataProviderRecord: TestDataProviderRecord) {
        self.init(
            id: dataProviderRecord.id,
            mapboxId: nil,
            type: dataProviderRecord.type.coreType,
            names: [dataProviderRecord.name],
            languages: ["en"]
        )
    }

    var id: String
    var mapboxId: String?
    var resultAccuracy: CoreAccuracy?
    var resultTypes: [CoreResultType]
    var type: CoreResultType { resultTypes.first ?? .unknown }
    var names: [String]
    var languages: [String]
    var addresses: [CoreAddress]?
    var addressDescription: String?
    var matchingName: String?
    var center: CLLocation?
    var categories: [String]?
    var routablePoints: [CoreRoutablePoint]?
    var icon: String?
    var layer: String?
    var userRecordID: String?
    var action: CoreSuggestAction?
    var serverIndex: NSNumber?
    var distance: NSNumber?
    var metadata: CoreResultMetadata?
    var estimatedTime: Measurement<UnitDuration>?

    var distanceToProximity: CLLocationDistance? {
        distance.map(\.doubleValue)
    }

    var dataLayerIdentifier: String { customDataLayerIdentifier ?? getLayerIdentifier() }
    var customDataLayerIdentifier: String?

    func getLayerIdentifier() -> String {
        switch type {
        case .place, .address, .poi:
            return SearchEngine.providerIdentifier
        default:
            fatalError("No identifier")
        }
    }
}

extension CoreSearchResultStub: Equatable {
    static func == (lhs: CoreSearchResultStub, rhs: CoreSearchResultStub) -> Bool {
        return lhs.id == rhs.id
            && lhs.type == rhs.type
            && lhs.names == rhs.names
            && lhs.languages == rhs.languages
            && lhs.addresses == rhs.addresses
            && lhs.center == rhs.center
            && lhs.categories == rhs.categories
            && lhs.icon == rhs.icon
            && lhs.layer == rhs.layer
            && lhs.userRecordID == rhs.userRecordID
            && lhs.action == rhs.action
            && lhs.serverIndex == rhs.serverIndex
            && lhs.distance == rhs.distance
    }
}

extension CoreSearchResultProtocol {
    var asCoreSearchResult: CoreSearchResult {
        CoreSearchResult(
            id: id,
            mapboxId: nil,
            types: resultTypes.map { NSNumber(value: $0.rawValue) },
            names: names,
            languages: languages,
            addresses: addresses,
            descrAddress: addressDescription,
            matchingName: matchingName,
            fullAddress: nil,
            distance: distance,
            eta: nil,
            center: center,
            accuracy: 100,
            routablePoints: routablePoints,
            categories: categories,
            categoryIDs: [],
            brand: [],
            brandID: nil,
            icon: icon,
            metadata: nil,
            externalIDs: nil,
            layer: layer,
            userRecordID: userRecordID,
            userRecordPriority: 100,
            action: action,
            serverIndex: serverIndex
        )
    }
}
