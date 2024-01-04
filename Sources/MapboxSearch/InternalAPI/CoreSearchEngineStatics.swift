import Foundation

enum CoreSearchEngineStatics {
    static func createTilesetDescriptor(dataset: String, version: String) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngine.createTilesetDescriptor(forDataset: dataset, version: version)
    }

    static func createPlacesTilesetDescriptor(dataset: String, version: String) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngine.createPlacesTilesetDescriptor(forDataset: dataset, version: version)
    }
}
