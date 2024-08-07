import Foundation

enum CoreSearchEngineStatics {
    enum Constants {
        static let delimiter = "_"
    }

    static func createTilesetDescriptor(dataset: String, version: String, language: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        let identifier: String
        if let language {
            if ISOLanguages.contains(language: language) {
                identifier = dataset + Constants.delimiter + language
            } else {
                _Logger.searchSDK
                    .warning(
                        "Provided language code '\(language)' for tileset is non-ISO. Dataset '\(dataset)' without language will be used."
                    )
                identifier = dataset
            }
        } else {
            identifier = dataset
        }
        return CoreSearchEngine.createTilesetDescriptor(forDataset: identifier, version: version)
    }

    static func createPlacesTilesetDescriptor(dataset: String, version: String, language: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        let identifier: String
        if let language {
            if ISOLanguages.contains(language: language) {
                identifier = dataset + Constants.delimiter + language
            } else {
                _Logger.searchSDK
                    .warning(
                        "Provided language code '\(language)' for places tileset is non-ISO. Dataset '\(dataset)' without language will be used."
                    )
                identifier = dataset
            }
        } else {
            identifier = dataset
        }
        return CoreSearchEngine.createPlacesTilesetDescriptor(forDataset: identifier, version: version)
    }
}

enum ISOLanguages {
    static func contains(language: String) -> Bool {
        var validLanguage: Bool = if #available(iOS 16, *) {
            Locale.LanguageCode.isoLanguageCodes
                .map(\.identifier)
                .contains(language)
        } else {
            Locale.isoLanguageCodes
                .contains(language)
        }
        return validLanguage
    }
}
