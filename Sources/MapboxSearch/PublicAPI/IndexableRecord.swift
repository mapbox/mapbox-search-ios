import CoreLocation

/// Defines data for index to represent external data to be included in search functionality
public protocol IndexableRecord {
    /// Record unique identifier
    var id: String { get }

    /// Record name
    var name: String { get }

    /// Record coordinates
    var coordinate: CLLocationCoordinate2D { get }

    /// Record address
    var address: Address? { get }

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

        return CoreUserRecord(
            id: id,
            name: name,
            center: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude),
            address: address?.coreAddress(),
            categories: nil,
            indexTokens: Array(tokens)
        )
    }
}
