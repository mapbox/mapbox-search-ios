import CoreLocation
@testable import MapboxSearch

class CoreSearchResultStub: CoreSearchResultProtocol {
    init(
        id: String,
        mapboxId: String?,
        resultAccuracy: CoreAccuracy? = nil,
        type: CoreResultType,
        names: [String] = ["sample-name1", "sample-name2"],
        namePreferred: String? = nil,
        languages: [String] = ["sample-language1", "sample-language2"],
        addresses: [CoreAddress]? = [Address.mapboxDCOffice.coreAddress()],
        addressDescription: String? = nil,
        matchingName: String? = nil,
        centerLocation: CLLocation? = .sample1,
        categories: [String]? = nil,
        categoryIDs: [String]? = nil,
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
        self.namePreferred = namePreferred
        self.languages = languages
        self.addresses = addresses
        self.addressDescription = addressDescription
        self.centerLocation = centerLocation
        self.categories = categories
        self.categoryIDs = categoryIDs
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
            mapboxId: dataProviderRecord.mapboxId,
            type: dataProviderRecord.type.coreType,
            names: [dataProviderRecord.name],
            languages: ["en"],
            categories: dataProviderRecord.categories,
            categoryIDs: dataProviderRecord.categoryIDs
        )
    }

    var id: String
    var mapboxId: String?
    var resultAccuracy: CoreAccuracy?
    var resultTypes: [CoreResultType]
    var type: CoreResultType { resultTypes.first ?? .unknown }
    var names: [String]
    var namePreferred: String?
    var languages: [String]
    var addresses: [CoreAddress]?
    var addressDescription: String?
    var matchingName: String?
    var centerLocation: CLLocation?
    var categories: [String]?
    var categoryIDs: [String]?
    var routablePoints: [CoreRoutablePoint]?
    var icon: String?
    var layer: String?
    var userRecordID: String?
    var action: CoreSuggestAction?
    var serverIndex: NSNumber?
    var distance: NSNumber?
    var metadata: CoreResultMetadata?
    var estimatedTime: Measurement<UnitDuration>?
    var externalIds: [String: String]?
    var brand: [String]?
    var brandID: String?

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
            && lhs.mapboxId == rhs.mapboxId
            && lhs.type == rhs.type
            && lhs.names == rhs.names
            && lhs.namePreferred == rhs.namePreferred
            && lhs.languages == rhs.languages
            && lhs.addresses == rhs.addresses
            && lhs.centerLocation == rhs.centerLocation
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
            mapboxId: mapboxId,
            types: resultTypes.map { NSNumber(value: $0.rawValue) },
            names: names,
            namePreferred: namePreferred,
            languages: languages,
            addresses: addresses,
            descrAddress: addressDescription,
            matchingName: matchingName,
            fullAddress: nil,
            distance: distance,
            eta: nil,
            center: centerLocation.map { Coordinate2D(value: $0.coordinate) },
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
            serverIndex: serverIndex,
            bbox: nil
        )
    }
}
