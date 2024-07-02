import Foundation

/// Contains details for top-level sub-national administrative features, such as states in the United States or
/// provinces in Canada or China, including name (required) and code identifiers (optional)
public struct SearchAddressRegion: Codable, Hashable, Equatable {
    /// Colloquial name for this region
    public let name: String

    /// Subdivision portion of ISO 3166-2 code
    public let regionCode: String?

    /// ISO 3166-2 region code
    public let regionCodeFull: String?

    init(_ core: CoreSearchAddressRegion) {
        self.name = core.name
        self.regionCode = core.regionCode
        self.regionCodeFull = core.regionCodeFull
    }
}

extension SearchAddressRegion {
    /// Transform a ``SearchAddressRegion`` to an object compatible with the MapboxCommon framework.
    func toCore() -> CoreSearchAddressRegion {
        CoreSearchAddressRegion(
            name: name,
            regionCode: regionCode,
            regionCodeFull: regionCodeFull
        )
    }
}
