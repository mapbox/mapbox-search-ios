import Foundation

public struct SearchAddressRegion: Codable, Hashable, Equatable {
    let name: String

    let regionCode: String?

    /// ISO 3166-2 region code
    let regionCodeFull: String?

    init(_ core: CoreSearchAddressRegion) {
        self.name = core.name
        self.regionCode = core.regionCode
        self.regionCodeFull = core.regionCodeFull
    }
}

extension SearchAddressRegion {
    func toCore() -> CoreSearchAddressRegion {
        CoreSearchAddressRegion(name: name,
                                regionCode: regionCode,
                                regionCodeFull: regionCodeFull)
    }
}
