import Foundation

/// Simple wrapper for `MapboxCommon.TileStore`.`
/// This instance provides basic `TileStore` functionality for a rare case when
/// someone using Offline search without other Mapbox frameworks.
///
/// Use `commonTileStore` property to access underlaying `MapboxCommon.TileStore`
public class SearchTileStore {
    /// Default API Url used for `Search` tile data domain.
    public let defaultEndPoint = "https://api.mapbox.com"

    /// Underlaying TileStore from MapboxCommon framework for use across Mapbox frameworks.
    public private(set) var commonTileStore: MapboxCommon.TileStore

    /// Creates with shared `MapboxCommon.TileStore` instance at the default location.
    /// Creates a new `MapboxCommon.TileStore` if one doesn't yet exist.
    public init() {
        self.commonTileStore = MapboxCommon.TileStore.__create()
        setup(tileStore: commonTileStore)
    }

    /// Creates with custom CommonTileStore.
    /// - Parameter commonTileStore: SearchEngine will start using provided TileStore
    public init(commonTileStore: MapboxCommon.TileStore) {
        self.commonTileStore = commonTileStore
        setup(tileStore: commonTileStore)
    }

    /// Creates with shared `MapboxCommon.TileStore` instance for the given storage path.
    /// Creates a new `MapboxCommon.TileStore` if one doesn't yet exist.
    /// If the given path is empty, the tile store at the default location is  returned.
    /// - Parameters:
    ///   - path: The path on disk where tiles and metadata will be stored.
    public init(path: String) {
        self.commonTileStore = MapboxCommon.TileStore.__create(forPath: path)
        setup(tileStore: commonTileStore)
    }

    // MARK: -

    func setup(tileStore: MapboxCommon.TileStore) {
        tileStore.setOptionForKey(
            MapboxCommon.TileStoreOptions.mapboxAPIURL,
            domain: MapboxCommon.TileDataDomain.search,
            value: defaultEndPoint
        )
    }

    /// Loads a new tile region or updates the existing one.
    /// - Parameters:
    ///   - id: The tile region identifier.
    ///   - options: The tile region load options.
    public func loadTileRegion(id: String, options: MapboxCommon.TileRegionLoadOptions) {
        commonTileStore.__loadTileRegion(forId: id, loadOptions: options)
    }

    /// Loads a new tile region or updates the existing one.
    /// - Parameters:
    ///   - id: The tile region identifier.
    ///   - options: The tile region load options.
    ///   - progress: Invoked multiple times to report progress of the loading
    ///         operation. Optional, default is nil.
    ///   - completion: Invoked only once upon success, failure, or cancelation
    ///         of the loading operation. Any `Result` error could be of type
    ///         `TileRegionError`.
    /// - Returns: A `Cancelable` object to cancel the load request
    public func loadTileRegion(
        id: String,
        options: MapboxCommon.TileRegionLoadOptions,
        progress: MapboxCommon.TileRegionLoadProgressCallback? = nil,
        completion: ((Result<MapboxCommon.TileRegion, TileRegionError>) -> Void)?
    )
    -> SearchCancelable {
        if let progress {
            let cancelable = commonTileStore.__loadTileRegion(
                forId: id,
                loadOptions: options,
                onProgress: progress
            ) { expected in
                completion?(makeResult(expected: expected, fallbackError: TileRegionError.other("Unexpected")))
            }
            return CommonCancelableWrapper(cancelable)
        } else {
            let cancelable = commonTileStore.__loadTileRegion(forId: id, loadOptions: options) { expected in
                completion?(makeResult(expected: expected, fallbackError: TileRegionError.other("Unexpected")))
            }
            return CommonCancelableWrapper(cancelable)
        }
    }

    /// Removes a tile region.
    ///
    /// Removes a tile region from the existing packages list. The actual resources
    /// eviction might be deferred. All pending loading operations for the tile region
    /// with the given id will fail with Canceled error.
    ///
    /// - Parameter id: The tile region identifier.
    public func removeTileRegion(id: String) {
        commonTileStore.removeTileRegion(forId: id)
    }

    /// Removes a tile region.
    ///
    /// Removes a tile region from the existing packages list. The actual resources
    /// eviction might be deferred. All pending loading operations for the tile region
    /// with the given id will fail with Canceled error.
    ///
    /// - Parameters:
    ///   - id: The tile region identifier.
    ///   - completion: Completion with `Result`, error could be of type `TileRegionError`.
    public func removeTileRegion(
        id: String,
        completion: ((Result<MapboxCommon.TileRegion, TileRegionError>) -> Void)?
    ) {
        commonTileStore.__removeTileRegion(forId: id) { expected in
            DispatchQueue.main.async {
                completion?(makeResult(expected: expected, fallbackError: TileRegionError.other("Unexpected")))
            }
        }
    }
}

private func makeResult<Value>(
    expected: CoreExpected<TileRegion, MapboxCommon.TileRegionError>,
    fallbackError: TileRegionError
) -> Result<Value, TileRegionError> {
    if expected.isValue(), let value = expected.value as? Value {
        return .success(value)
    } else if expected.isError() {
        return .failure(TileRegionError(coreError: expected.error))
    } else {
        return .failure(fallbackError)
    }
}
