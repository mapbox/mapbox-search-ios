import Foundation

enum CoreSearchEngineStatics {
    static func createTilesetDescriptor(
        tilesetParameters: TilesetParameters
    ) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngine.createTilesetDescriptor(
            forDataset: tilesetParameters.generatedDatasetName,
            version: tilesetParameters.validatedVersion
        )
    }

    static func createPlacesTilesetDescriptor(
        tilesetParameters: TilesetParameters
    ) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngine.createPlacesTilesetDescriptor(
            forDataset: tilesetParameters.generatedDatasetName,
            version: tilesetParameters.validatedVersion
        )
    }
}
