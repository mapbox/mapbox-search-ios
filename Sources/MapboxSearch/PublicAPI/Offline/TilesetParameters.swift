/// Represents the parameters for a tileset.
public struct TilesetParameters: Equatable, Sendable {
    /// The dataset name.
    public let dataset: String
    /// The dataset version.
    public let version: String?
    /// The language for the tileset.
    /// This value should be an ISO 639-1 language code from Locale.
    public let language: String?
    /// The worldview for the tileset. This property requires an explicit language specification.
    /// This value should be an ISO 3166 alpha-2 country code from Locale.
    public let worldview: String?

    public init(dataset: String, version: String? = nil, language: String? = nil, worldview: String? = nil) {
        self.dataset = dataset
        self.version = version
        self.language = language
        self.worldview = worldview
    }
}

extension TilesetParameters {
    enum Constants {
        static let languageDelimiter = "_"
        static let worldviewDelimiter = "-"
    }

    var validatedVersion: String {
        version ?? ""
    }

    var generatedDatasetName: String {
        if let worldview, language == nil {
            _Logger.searchSDK.warning(
                "Language must be present when worldview \(worldview) is specified."
            )
        }
        var identifier = dataset
        guard let language = language?.lowercased() else {
            return identifier
        }

        if ISOLanguages.contains(language: language) {
            identifier += Constants.languageDelimiter + language

            if let worldview = worldview?.uppercased() {
                if ISORegiones.contains(code: worldview) {
                    identifier += Constants.worldviewDelimiter + worldview.lowercased()
                } else {
                    _Logger.searchSDK.warning(
                        "Provided worldview '\(worldview)' for tileset is non an ISO 3166 alpha-2 code."
                    )
                }
            }
        } else {
            _Logger.searchSDK.warning(
                "Provided language code '\(language)' for tileset is non ISO 639-1. Dataset '\(dataset)' without language will be used."
            )
        }
        return identifier
    }
}

enum ISOLanguages {
    static func contains(language: String) -> Bool {
        if #available(iOS 16, *) {
            Locale.LanguageCode.isoLanguageCodes
                .map(\.identifier)
                .contains(language)
        } else {
            Locale.isoLanguageCodes.contains(language)
        }
    }
}

enum ISORegiones {
    static func contains(code: String) -> Bool {
        if #available(iOS 16, *) {
            Locale.Region.isoRegions
                .map(\.identifier)
                .contains(code)
        } else {
            Locale.isoRegionCodes.contains(code)
        }
    }
}
