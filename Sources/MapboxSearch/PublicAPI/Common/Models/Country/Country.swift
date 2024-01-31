import Foundation

public struct Country: Equatable {
    public let countryCode: String

    /// Country model initializer
    /// - Parameter countryCode: Permitted values are ISO 3166-1 alpha 2 country codes (e.g. US, DE, GB)
    public init?(countryCode: String) {
        guard ISO3166_1_alpha2(rawValue: countryCode.uppercased()) != nil else {
            return nil
        }

        self.countryCode = countryCode.lowercased()
    }

    init(code: ISO3166_1_alpha2) {
        self.countryCode = code.rawValue.lowercased()
    }

    /// Detect the system region ISO3166\_1\_Alpha2 identifier and return an instance for it
    static var `default`: Self? {
        if #available(iOS 16, *) {
            return Country(countryCode: Locale.current.region?.identifier ?? "")
        } else {
            let regionComponents = Locale.current.identifier.components(separatedBy: "_")
            if regionComponents.count >= 2 {
                let countryIdentifier = regionComponents[1]
                return Country(countryCode: countryIdentifier)
            } else {
                return nil
            }
        }
    }
}
