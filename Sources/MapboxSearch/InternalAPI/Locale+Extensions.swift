import Foundation

extension Locale {
    static let defaultLanguage = "en"
}

extension Locale {
    static func defaultLanguages() -> [String] {
        let regions = Locale.preferredLanguages.map(Locale.init).compactMap(\.languageCode).removingDuplicates()

        if let first = regions.first {
            return [first]
        } else {
            return [Locale.defaultLanguage]
        }
    }
}
