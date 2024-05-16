import Foundation

/// OfflineManager handles `TileStore`s and responsible for creating Search `TilsetDescriptor`s
public class SearchOfflineManager {
    static let defaultDatasetName = "mbx-main"

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
    ///   - accessToken: Mapbox Access Token.
    ///   - completion: this completion called right after SearchEngine finished consuming data from provided TileStore.
    /// One can start using offline search after that.
    public func setTileStore(
        _ tileStore: MapboxCommon.TileStore,
        accessToken: String,
        completion: (() -> Void)? = nil
    ) {
        let searchTileStore = SearchTileStore(commonTileStore: tileStore, accessToken: accessToken)
        self.tileStore = searchTileStore
        engine.setTileStore(searchTileStore.commonTileStore, completion: completion)
    }

    /// Creates TilesetDescriptor for offline search index data with provided dataset name and version.
    /// - Parameters:
    ///   - dataset: dataset name
    ///   - version: dataset version
    /// - Returns: TilesetDescriptor for TileStore
    public static func createTilesetDescriptor(dataset: String, version: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        CoreSearchEngineStatics.createTilesetDescriptor(dataset: dataset, version: version ?? "")
    }

    /// Creates TilesetDescriptor for offline search boundaries with provided dataset name and version.
    /// - Parameters:
    ///   - dataset: dataset name
    ///   - version: dataset version
    /// - Returns: TilesetDescriptor for TileStore
    public static func createPlacesTilesetDescriptor(dataset: String, version: String? = nil) -> MapboxCommon
    .TilesetDescriptor {
        CoreSearchEngineStatics.createPlacesTilesetDescriptor(dataset: dataset, version: version ?? "")
    }

    /// Creates TilesetDescriptor for offline search index data using default dataset name.
    /// - Returns: TilesetDescriptor for TileStore
    public static func createDefaultTilesetDescriptor() -> MapboxCommon.TilesetDescriptor {
        createTilesetDescriptor(dataset: defaultDatasetName, version: nil)
    }

    /// Creates TilesetDescriptor for offline search boundaries using default dataset name.
    /// - Returns: TilesetDescriptor for TileStore
    public static func createDefaultPlacesTilesetDescriptor() -> MapboxCommon.TilesetDescriptor {
        createPlacesTilesetDescriptor(dataset: defaultDatasetName, version: nil)
    }
}
