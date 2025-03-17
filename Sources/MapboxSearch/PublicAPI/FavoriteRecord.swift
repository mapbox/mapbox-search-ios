import CoreLocation

/// Resolved search result intended to represent user favorites
public struct FavoriteRecord: IndexableRecord, SearchResult, Codable, Equatable {
    /// Unique record identifier.
    public let id: String

    /// Displayable name of the record.
    public var name: String

    /// A unique identifier for the geographic feature
    public var mapboxId: String?

    /// The feature name, as matched by the search algorithm.
    /// Not available in ``ApiType/searchBox`` results.
    /// - Warning: The field is exposed for compatibility only and should be considered deprecated.
    public var matchingName: String?

    /// address formatted with medium style.
    public var descriptionText: String?

    /// Coordinate associated to the favorite record.
    public internal(set) var coordinate: CLLocationCoordinate2D {
        get {
            coordinateCodable.coordinates
        }
        set {
            coordinateCodable = .init(newValue)
        }
    }

    var coordinateCodable: CLLocationCoordinate2DCodable

    /// An approximate distance to the origin location, in meters.
    public var distance: CLLocationDistance?

    /// Result address.
    public var address: Address?

    /// Maki icon name.
    public var icon: Maki?

    /// Index in response from server.
    public let serverIndex: Int?

    /// A point accuracy metric for the returned address.
    public let accuracy: SearchResultAccuracy?

    /// Maki icon name. Use ``icon`` when possible.
    public var iconName: String?

    public var makiIcon: String? {
        icon?.name
    }

    /// Result categories types.
    public var categories: [String]?

    /// Coordinates of building entries
    public var routablePoints: [RoutablePoint]?

    /// Type of SearchResult. Should be one of address or POI.
    public var type: SearchResultType

    /// Additional string literals that should be included in object index. For example, you may provide non-official
    /// names to force `SearchEngine` match them.
    public var additionalTokens: Set<String>?

    /// FavoriteRecord Always has estimatedTime as nil.
    public var estimatedTime: Measurement<UnitDuration>?

    /// Original search request.
    public let searchRequest: SearchRequestOptions

    /// Associated metadata
    public var metadata: SearchResultMetadata?

    /// Favorite record constructor
    /// - Parameters:
    ///   - id: UUID used by default
    ///   - mapboxId: Unique record identifier
    ///   - name: Favorite name
    ///   - matchingName: The feature name, as matched by the search algorithm
    ///   - coordinate: Favorite coordinate
    ///   - distance: An approximate distance to the origin location, in meters
    ///   - address: Favorite address
    ///   - makiIcon:Favorite  icon name
    ///   - serverIndex: The index in response from server
    ///   - accuracy: A point accuracy metric for the returned address
    ///   - categories: Favorite categories list
    ///   - routablePoints: Coordinates of building entries
    ///   - searchRequest: original search request
    ///   - metadata: Associated metadata
    ///   - resultType: Favorite result type
    ///   - descriptionText: Address formatted with the medium style
    public init(
        id: String? = nil,
        mapboxId: String? = nil,
        name: String,
        matchingName: String?,
        coordinate: CLLocationCoordinate2D,
        distance: CLLocationDistance? = nil,
        address: Address?,
        makiIcon: Maki?,
        serverIndex: Int?,
        accuracy: SearchResultAccuracy?,
        categories: [String]?,
        routablePoints: [RoutablePoint]? = nil,
        resultType: SearchResultType,
        searchRequest: SearchRequestOptions,
        metadata: SearchResultMetadata? = nil,
        descriptionText: String? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.mapboxId = mapboxId
        self.name = name
        self.matchingName = matchingName
        self.coordinateCodable = .init(coordinate)
        self.distance = distance
        self.address = address
        self.icon = makiIcon
        self.serverIndex = serverIndex
        self.accuracy = accuracy
        self.categories = categories
        self.routablePoints = routablePoints
        self.type = resultType
        self.metadata = metadata
        self.searchRequest = searchRequest
        self.descriptionText = descriptionText ?? address?.formattedAddress(style: .medium)
    }

    /// Build Favorite record from SearchResult
    /// - Parameters:
    ///   - id: UUID used by default
    ///   - name: Favorite name
    ///   - searchResult: search result to use for FavoriteRecord
    public init(
        id: String? = nil,
        name: String,
        searchResult: SearchResult
    ) {
        self.init(
            id: id,
            mapboxId: searchResult.mapboxId,
            name: name,
            matchingName: searchResult.matchingName,
            coordinate: searchResult.coordinate,
            distance: searchResult.distance,
            address: searchResult.address,
            makiIcon: searchResult.iconName.flatMap(Maki.init),
            serverIndex: searchResult.serverIndex,
            accuracy: searchResult.accuracy,
            categories: searchResult.categories,
            routablePoints: searchResult.routablePoints,
            resultType: searchResult.type,
            searchRequest: searchResult.searchRequest,
            metadata: searchResult.metadata
        )
    }
}
