import Foundation

enum CoreSearchEngineStatics {
    enum Constants {
        static let delimiter = "_"
    }

    static func createTilesetDescriptor(dataset: String, version: String, language: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        let identifier: String
        if let language, ISOLanguages.contains(language: language) {
            identifier = dataset + Constants.delimiter + language
        } else {
            identifier = dataset
        }
        return CoreSearchEngine.createTilesetDescriptor(forDataset: identifier, version: version)
    }

    static func createPlacesTilesetDescriptor(dataset: String, version: String, language: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        let identifier: String
        if let language, ISOLanguages.contains(language: language) {
            identifier = dataset + Constants.delimiter + language
        } else {
            identifier = dataset
        }
        return CoreSearchEngine.createPlacesTilesetDescriptor(forDataset: identifier, version: version)
    }
}

enum ISOLanguages {
    static func contains(language: String) -> Bool {
        var validLanguage: Bool
        if #available(iOS 16, *) {
            validLanguage = Locale.LanguageCode.isoLanguageCodes
                .map(\.identifier)
                .contains(language)
        } else {
            validLanguage = Locale.isoLanguageCodes
                .contains(language)
        }
        return validLanguage
    }
}
