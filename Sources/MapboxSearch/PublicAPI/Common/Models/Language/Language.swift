import Foundation

public struct Language: Equatable {
    public let languageCode: String

    /// Language model initializier
    /// - Parameter languageCode: Permitted values are ISO 639-1 language codes
    public init?(languageCode: String) {
        guard let isoCode = ISO639_1(rawValue: languageCode.lowercased()) else {
            return nil
        }

        self.languageCode = isoCode.rawValue
    }

    /// Language model initializier
    /// - Parameter locale: only `languageCode` component is used if exist.
    public init?(locale: Locale) {
        guard let isoCode = locale.languageCode.flatMap(ISO639_1.init(rawValue:)) else {
            return nil
        }

        self.languageCode = isoCode.rawValue
    }

    static var `default`: Self {
        let regions = Locale.preferredLanguages.map(Locale.init).compactMap(\.languageCode).removingDuplicates()
        let defaultLanguage = Language(languageCode: "en")!

        if let first = regions.first {
            return Language(languageCode: first) ?? defaultLanguage
        } else {
            return defaultLanguage
        }
    }
}
