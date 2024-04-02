import Foundation
import MapboxCommon

extension TileRegionLoadOptions {
    /// Builds a `TileRegionLoadOptions`, required for
    /// `TileStore.loadTileRegion(forId:loadOptions:)`
    ///
    /// - Parameters:
    ///   - geometry: The tile region's associated geometry (optional).
    ///   - descriptors: The tile region's tileset descriptors.
    ///   - metadata: A custom JSON value to be associated with this tile region.
    ///   - networkRestriction: Restrict the tile region load request to the
    ///         specified network types. If none of the specified network types
    ///         is available, the load request fails with an error.
    ///   - averageBytesPerSecond: Limits the download speed of the tile region.
    ///   - extraOptions: Provide extra options, such as forceRefresh (will use `false` by default) in a container
    /// struct. Nil input will use default behavior.
    ///
    ///
    /// `averageBytesPerSecond` is not a strict bandwidth limit, but only
    /// limits the average download speed. tile regions may be temporarily
    /// downloaded with higher speed, then pause downloading until the rolling
    /// average has dropped below this value.
    ///
    /// If `metadata` is not a valid JSON object, then this initializer returns
    /// `nil`.
    public static func build(
        geometry: Geometry?,
        descriptors: [TilesetDescriptor]?,
        metadata: Any? = nil,
        acceptExpired: Bool = false,
        networkRestriction: NetworkRestriction = .none,
        averageBytesPerSecond: Int? = nil,
        extraOptions: ExtraOptions? = nil
    ) -> TileRegionLoadOptions? {
        if let metadata {
            guard JSONSerialization.isValidJSONObject(metadata) else {
                return nil
            }
        }

        return TileRegionLoadOptions(
            __geometry: geometry,
            descriptors: descriptors,
            metadata: metadata,
            acceptExpired: acceptExpired,
            networkRestriction: networkRestriction,
            startLocation: nil,
            averageBytesPerSecond: averageBytesPerSecond.map(NSNumber.init(value:)),
            extraOptions: extraOptions?.toCore()
        )
    }
}

extension TileRegionLoadOptions {
    /// Wraps extra options with Core-compatible inputs for building a `TileRegionLoadOptions`. Providing nil instead
    public struct ExtraOptions {
        /// If set to a true boolean value, all tiles in the group will be loaded instead of loading only missing or
        /// expired tiles. Default value is false.
        public var forceRefresh: Bool

        public init(forceRefresh: Bool = false) {
            self.forceRefresh = forceRefresh
        }

        /// Provide a Core-compatible object
        func toCore() -> [String: Any] {
            [
                "force_refresh": forceRefresh,
            ]
        }
    }
}
