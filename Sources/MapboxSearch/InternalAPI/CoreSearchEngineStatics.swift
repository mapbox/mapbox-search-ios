import Foundation

enum CoreSearchEngineStatics {
    static func createTilesetDescriptor(dataset: String, version: String, language: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        let identifier: String
        if let language {
            identifier = dataset + "|" + language
        } else {
            identifier = dataset
        }
        return CoreSearchEngine.createTilesetDescriptor(forDataset: identifier, version: version)
    }

    static func createPlacesTilesetDescriptor(dataset: String, version: String, language: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        let identifier: String
        if let language {
            identifier = dataset + "|" + language
        } else {
            identifier = dataset
        }
        return CoreSearchEngine.createPlacesTilesetDescriptor(forDataset: identifier, version: version)
    }
}
