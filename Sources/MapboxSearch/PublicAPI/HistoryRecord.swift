import CoreLocation

/// Resolved search result intended to represent user search history
public struct HistoryRecord: IndexableRecord, SearchResult, Codable, Hashable {
    /// "history icon" by default
    public var iconName: String? = "history icon"

    public var makiIcon: String? { iconName }

    /// Type of stored history record
    public enum HistoryType: Int, Codable {
        /// History record was build based on search result
        case result

        /// Search query was saved as history record
        case query

        /// Category search was saved as history record
        case category
    }

    /// Unique identifier
    public private(set) var id: String

    public private(set) var mapboxId: String?

    /// Record's name
    public private(set) var name: String

    /// Index in response from server.
    public let serverIndex: Int?

    /// A point accuracy metric for the returned address.
    public let accuracy: SearchResultAccuracy?

    /// The feature name, as matched by the search algorithm.
    /// Not available in ``ApiType/searchBox`` results.
    /// - Warning: The field is exposed for compatibility only and should be considered deprecated.
    public private(set) var matchingName: String?

    /// Address formatted with medium style
    public var descriptionText: String?

    /// Coordinate associated with the record
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

    /// The time when the record was created.
    public private(set) var timestamp: Date

    /// Type of object used to make a history record, e.g. result or query
    public private(set) var historyType: HistoryType

    /// Original result type of object, e.g. address or POI
    public private(set) var type: SearchResultType

    /// FavoriteRecord Always has estimatedTime as nil.
    public var estimatedTime: Measurement<UnitDuration>?

    /// Associated metadata at creating time if available.
    public var metadata: SearchResultMetadata?

    /// Address components of specific record
    public var address: Address?

    /// Additional indexable tokens for search engine
    ///
    /// SearchEngine would track that tokens to match results
    public var additionalTokens: Set<String>?

    /// Categories associated with original result
    public var categories: [String]?

    /// Original search request.
    public let searchRequest: SearchRequestOptions

    /// Coordinates of building entries
    public var routablePoints: [RoutablePoint]?

    /// History record constructor
    /// - Parameters:
    ///   - id: UUID used by default
    ///   - mapboxId: Unique record identifier
    ///   - name: History name
    ///   - matchingName: The feature name, as matched by the search algorithm
    ///   - serverIndex: The index in response from server
    ///   - accuracy: A point accuracy metric for the returned address
    ///   - coordinate: History coordinate
    ///   - distance: An approximate distance to the origin location, in meters
    ///   - timestamp: History timestamp
    ///   - historyType: History type
    ///   - type: History type
    ///   - address: History address
    ///   - metadata: Associated metadata
    ///   - categories: Categories of original object
    ///   - searchRequest: The original search request
    ///   - routablePoints: Coordinates of building entries
    ///   - descriptionText: Address formatted with the medium style
    public init(
        id: String = UUID().uuidString,
        mapboxId: String?,
        name: String,
        matchingName: String?,
        serverIndex: Int?,
        accuracy: SearchResultAccuracy?,
        coordinate: CLLocationCoordinate2D,
        distance: CLLocationDistance? = nil,
        timestamp: Date = Date(),
        historyType: HistoryRecord.HistoryType,
        type: SearchResultType,
        address: Address?,
        metadata: SearchResultMetadata? = nil,
        categories: [String]? = nil,
        searchRequest: SearchRequestOptions,
        routablePoints: [RoutablePoint]? = nil,
        descriptionText: String? = nil
    ) {
        self.id = id
        self.mapboxId = mapboxId
        self.name = name
        self.matchingName = matchingName
        self.serverIndex = serverIndex
        self.accuracy = accuracy
        self.coordinateCodable = .init(coordinate)
        self.distance = distance
        self.timestamp = timestamp
        self.historyType = historyType
        self.type = type
        self.address = address
        self.metadata = metadata
        self.categories = categories
        self.searchRequest = searchRequest
        self.routablePoints = routablePoints
        self.descriptionText = descriptionText ?? address?.formattedAddress(style: .medium)
    }

    /// Construct `HistoryRecord` based on concrete `SearchResult`
    /// - Parameters:
    ///   - historyType: Type of history result
    ///   - searchResult: Prototype result
    ///   - timestamp: creating timestamp. Calling time by default
    public init(
        historyType: HistoryRecord.HistoryType = .result,
        searchResult: SearchResult,
        timestamp: Date = Date()
    ) {
        self.id = searchResult.id
        self.mapboxId = searchResult.mapboxId
        self.name = searchResult.name
        self.matchingName = searchResult.matchingName
        self.serverIndex = searchResult.serverIndex
        self.accuracy = searchResult.accuracy
        self.coordinateCodable = .init(searchResult.coordinate)
        self.distance = searchResult.distance
        self.timestamp = timestamp
        self.historyType = historyType
        self.type = searchResult.type
        self.address = searchResult.address
        self.metadata = searchResult.metadata
        self.categories = searchResult.categories
        self.searchRequest = searchResult.searchRequest
        self.routablePoints = searchResult.routablePoints
        self.descriptionText = searchResult.descriptionText
    }
}
