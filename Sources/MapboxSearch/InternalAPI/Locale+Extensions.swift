import Foundation

extension Locale {
    static let defaultLanguage = "en"
}

extension Locale {
    static func defaultLanguages() -> [String] {
        let regions = Locale.preferredLanguages.map(Locale.init).compactMap({ $0.languageCode }).removingDuplicates()
        if regions.isEmpty {
            return [Locale.defaultLanguage]
        } else {
            return regions
        }
    }
}
