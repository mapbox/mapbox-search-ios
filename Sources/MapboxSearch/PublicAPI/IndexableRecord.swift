import CoreLocation

/// Defines data for index to represent external data to be included in search functionality
public protocol IndexableRecord {
    // MARK: Required Fields

    /// Record unique identifier.
    var id: String { get }

    /// Record name.
    var name: String { get }

    /// Record coordinates.
    var coordinate: CLLocationCoordinate2D { get }

    /// Type of the search result represented by the record.
    var type: SearchResultType { get }

    // MARK: Optional Fields

    /// Additional description for this record.
    var descriptionText: String? { get }

    /// Record address.
    var address: Address? { get }

    /// List of points near `coordinate`, that represent entries to the associated building.
    var routablePoints: [RoutablePoint]? { get }

    /// Record categories.
    var categories: [String]? { get }

    /// Mapbox Maki icon ID.
    var makiIcon: String? { get }

    /// Search result metadata containing this place's detailed information if available.
    var metadata: SearchResultMetadata? { get }

    /// Additional string literals that should be included in object index. For example, you may provide non-official
    /// names to force `SearchEngine` match them.
    var additionalTokens: Set<String>? { get }
}

extension IndexableRecord {
    func coreUserRecord() -> CoreUserRecord {
        var tokens = additionalTokens ?? []
        [address?.houseNumber, address?.street, address?.place]
            .compactMap { $0 }
            .forEach { tokens.insert($0) }

        /// Fallback value for a nil result type is CoreResultType.unknown
        let coreType: CoreResultType? = switch type {
        case .POI:
            CoreResultType.poi
        case .address(let subtypes):
            subtypes.first?.toCore()
        }

        return CoreUserRecord(
            id: id,
            name: name,
            center: Coordinate2D(value: coordinate),
            address: address?.coreAddress(),
            categories: nil,
            indexTokens: Array(tokens),
            from: coreType ?? .unknown
        )
    }
}
