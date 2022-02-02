import CoreLocation

/// Resolved search result intended to represent user favorites
public struct FavoriteRecord: IndexableRecord, SearchResult, Codable, Equatable {
    
    /// Unique record identifier.
    public let id: String
    
    /// Displayable name of the record.
    public var name: String
    
    /**
        The feature name, as matched by the search algorithm.
        
        - Warning: The field is exposed for compatibility only, will be removed soon.
    */
    public var matchingName: String?
    
    /// address formatted with medium style.
    public var descriptionText: String? { address?.formattedAddress(style: .medium) }
    
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
    
    /// Result address.
    public var address: Address?
    
    /// Maki icon name.
    public var icon: Maki?
    
    /// Maki icon name. Use ``icon`` when possible.
    public var iconName: String?
    
    /// Result categories types.
    public var categories: [String]?
    
    /// Coordinates of building entries
    public var routablePoints: [RoutablePoint]?
    
    /// Type of SearchResult. Should be one of address or POI.
    public var type: SearchResultType
    
    /// Additional string literals that should be included in object index. For example, you may provide non-official names to force `SearchEngine` match them.
    public var additionalTokens: Set<String>?
    
    /// FavoriteRecord Always has estimatedTime as nil.
    public var estimatedTime: Measurement<UnitDuration>?
    
    /// Associated metadata
    public var metadata: SearchResultMetadata?
    
    /// Favorite record constructor
    /// - Parameters:
    ///   - id: UUID used by default
    ///   - name: Favorite name
    ///   - coordinate: Favorite coordinate
    ///   - address: Favorite address
    ///   - makiIcon:Favorite  icon name
    ///   - categories: Favorite categories list
    ///   - resultType: Favorite result type
    public init(
        id: String? = nil,
        name: String,
        matchingName: String?,
        coordinate: CLLocationCoordinate2D,
        address: Address?,
        makiIcon: Maki?,
        categories: [String]?,
        routablePoints: [RoutablePoint]? = nil,
        resultType: SearchResultType,
        metadata: SearchResultMetadata? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.matchingName = matchingName
        self.coordinateCodable = .init(coordinate)
        self.address = address
        self.icon = makiIcon
        self.categories = categories
        self.type = resultType
        self.metadata = metadata
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
        self.init(id: id,
                  name: name,
                  matchingName: searchResult.matchingName,
                  coordinate: searchResult.coordinate,
                  address: searchResult.address,
                  makiIcon: searchResult.iconName.flatMap(Maki.init),
                  categories: searchResult.categories,
                  routablePoints: searchResult.routablePoints,
                  resultType: searchResult.type,
                  metadata: searchResult.metadata)
    }
} 
