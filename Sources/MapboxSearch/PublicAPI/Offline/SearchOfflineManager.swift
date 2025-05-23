import Foundation

/// OfflineManager handles `TileStore`s and responsible for creating Search `TilsetDescriptor`s
public class SearchOfflineManager {
    static let defaultDatasetName = "mbx-gen2"

    var engine: CoreSearchEngineProtocol

    /// TileStore for offline tiles management.
    /// Use `setTileStore` method to change current tileStore.
    public private(set) var tileStore: SearchTileStore

    init(engine: CoreSearchEngineProtocol, tileStore: SearchTileStore) {
        self.engine = engine
        self.tileStore = tileStore
    }

    func registerCurrentTileStore(completion: (() -> Void)?) {
        setTileStore(tileStore, completion: completion)
    }

    /// Sets custom tile store. You can provide MapboxCommon.TileStore by wrapping it into MapboxSearch.SearchTileStore
    /// `init(commonTileStore: CommonTileStore)`
    /// - Parameters:
    ///   - tileStore: TileStore to set into SearchEngine
    ///   - completion: this completion called right after SearchEngine finished consuming data from provided TileStore.
    /// One can start using offline search after that.
    public func setTileStore(_ tileStore: SearchTileStore, completion: (() -> Void)? = nil) {
        self.tileStore = tileStore
        engine.setTileStore(tileStore.commonTileStore, completion: completion)
    }

    /// Sets custom tile store.
    /// - Parameters:
    ///   - tileStore: TileStore to set into SearchEngine.
    ///   - completion: this completion called right after SearchEngine finished consuming data from provided TileStore.
    /// One can start using offline search after that.
    public func setTileStore(_ tileStore: MapboxCommon.TileStore, completion: (() -> Void)? = nil) {
        let searchTileStore = SearchTileStore(commonTileStore: tileStore)
        self.tileStore = searchTileStore
        engine.setTileStore(searchTileStore.commonTileStore, completion: completion)
    }

    public func selectTileset(for dataset: String?, version: String? = nil) {
        engine.selectTileset(for: dataset, version: version)
    }

    public func selectTileset(for tilesetParameters: TilesetParameters) {
        engine.selectTileset(for: tilesetParameters.generatedDatasetName, version: tilesetParameters.validatedVersion)
    }

    // MARK: - Tileset with name, version, and language parameters

    /// Creates TilesetDescriptor for offline search index data with provided dataset name, version, and language.
    /// Providing nil or excluding the language parameter will use the dataset name as-is.
    /// Providing a language will append it to the name.
    /// - Parameters:
    ///   - dataset: dataset name
    ///   - version: dataset version
    ///   - language: Provide a ISO 639-1 Code language from NSLocale. Values will be appended to the place dataset
    /// name.
    /// - Returns: TilesetDescriptor for TileStore
    @available(*, deprecated, message: "Use SearchOfflineManager.createTilesetDescriptor(tilesetParameters:) instead.")
    public static func createTilesetDescriptor(
        dataset: String,
        version: String? = nil,
        language: String? = nil
    ) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngineStatics.createTilesetDescriptor(
            tilesetParameters: .init(
                dataset: dataset,
                version: version,
                language: language
            )
        )
    }

    /// Creates TilesetDescriptor for offline search index data with provided dataset name, version, language, and worldview.
    /// Providing nil or excluding the language parameter will use the dataset name as-is.
    /// Providing a language will append it to the name.
    /// - Parameter tilesetParameters: The tileset parameters.
    /// - Returns: TilesetDescriptor for TileStore.
    public static func createTilesetDescriptor(
        tilesetParameters: TilesetParameters
    ) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngineStatics.createTilesetDescriptor(
            tilesetParameters: tilesetParameters
        )
    }

    /// Creates TilesetDescriptor for offline search boundaries with provided dataset name and version.
    /// Providing nil or excluding the language parameter will use the places dataset name as-is.
    /// Providing a language will append it to the name.
    /// - Parameters:
    ///   - dataset: dataset name
    ///   - version: dataset version
    ///   - language: Provide a ISO 639-1 Code language from NSLocale. Values will be appended to the dataset name.
    /// - Returns: TilesetDescriptor for TileStore
    @available(*, deprecated, message: "Use SearchOfflineManager.createPlacesTilesetDescriptor(tilesetParameters:) instead.")
    public static func createPlacesTilesetDescriptor(
        dataset: String,
        version: String? = nil,
        language: String? = nil
    ) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngineStatics.createPlacesTilesetDescriptor(
            tilesetParameters: .init(
                dataset: dataset,
                version: version,
                language: language
            )
        )
    }
    /// Creates TilesetDescriptor for offline search boundaries with provided dataset name, version, language, and worldview.
    /// Providing nil or excluding the language parameter will use the places dataset name as-is.
    /// Providing a language will append it to the name.
    /// - Parameter tilesetParameters: The tileset parameters.
    /// - Returns: TilesetDescriptor for TileStore.
    public static func createPlacesTilesetDescriptor(
        tilesetParameters: TilesetParameters
    ) -> MapboxCommon.TilesetDescriptor {
        CoreSearchEngineStatics.createTilesetDescriptor(
            tilesetParameters: tilesetParameters
        )
    }

    // MARK: - Default tileset

    /// Creates TilesetDescriptor for offline search index data using default dataset name.
    /// - Returns: TilesetDescriptor for TileStore
    public static func createDefaultTilesetDescriptor() -> MapboxCommon.TilesetDescriptor {
        createTilesetDescriptor(tilesetParameters: .init(dataset: defaultDatasetName))
    }

    /// Creates TilesetDescriptor for offline search boundaries using default dataset name.
    /// - Returns: TilesetDescriptor for TileStore
    public static func createDefaultPlacesTilesetDescriptor() -> MapboxCommon.TilesetDescriptor {
        createPlacesTilesetDescriptor(tilesetParameters: .init(dataset: defaultDatasetName))
    }
}
