import CoreLocation
import Foundation

protocol CoreSearchEngineProtocol {
    /**
     -------------------------------------------------------------------------------------------
     @brief Create user data layer.
     @param[in] layer     Unique layer name.
     @param[in] priority  Priority compared with other layers. Bigger is higher in result's list.
     */
    func createUserLayer(_ layer: String, priority: Int32) -> CoreUserRecordsLayerProtocol

    /// Adds user layer into search engine. Should be thread safe
    /// - Parameter layer: layer to add
    func addUserLayer(_ layer: CoreUserRecordsLayerProtocol)

    /// Removes layer from search engine. Adding/removing/updating records should be done with removed layer.
    /// - Parameter layer: layer to remove
    func removeUserLayer(_ layer: CoreUserRecordsLayerProtocol)
    /**
     @brief Main (1st step) search function.
     \a query and \a category can be empty.
     */
    func search(
        forQuery query: String,
        categories: [String],
        options: CoreSearchOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    )

    /** @brief Continue (next steps) search function. */
    func nextSearch(
        for result: CoreSearchResultProtocol,
        with originalRequest: CoreRequestOptions,
        callback: @escaping (CoreSearchResponseProtocol?) -> Void
    )

    /** @brief Batch retrieve for a list of POI suggestions. */
    func batchResolve(
        results: [CoreSearchResultProtocol],
        with originalRequest: CoreRequestOptions,
        callback: @escaping (CoreSearchResponseProtocol?) -> Void
    )
    /**
     @brief Call to notify that result was selected.
     Causes adding to the history, ending current session, billing, telemetry event.
     */
    func onSelected(forRequest request: CoreRequestOptions, result: CoreSearchResultProtocol)

    /// @brief Create json feedback event.
    func makeFeedbackEvent(
        request: CoreRequestOptions,
        result: CoreSearchResultProtocol?,
        callback: @escaping (String) -> Void
    ) throws

    func reverseGeocoding(
        for options: CoreReverseGeoOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    )

    func searchOffline(
        query: String,
        categories: [String],
        options: CoreSearchOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    )

    func getOfflineAddress(
        street: String,
        proximity: CLLocationCoordinate2D,
        radius: Double,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    )

    func reverseGeocodingOffline(
        for options: CoreReverseGeoOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    )

    func setTileStore(_ tileStore: MapboxCommon.TileStore, completion: (() -> Void)?)

    func setTileStore(_ tileStore: MapboxCommon.TileStore)

    func addOfflineIndexObserver(for observer: CoreOfflineIndexObserver)

    func removeOfflineIndexObserver(for observer: CoreOfflineIndexObserver)
}

extension CoreSearchEngine: CoreSearchEngineProtocol {
    func setTileStore(_ tileStore: MapboxCommon.TileStore, completion: (() -> Void)?) {
        setTileStoreFor(tileStore) {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func setTileStore(_ tileStore: MapboxCommon.TileStore) {
        setTileStoreFor(tileStore)
    }

    func makeFeedbackEvent(
        request: CoreRequestOptions,
        result: CoreSearchResultProtocol?,
        callback: @escaping (String) -> Void
    ) throws {
        if let result {
            if let coreResult = result as? CoreSearchResult {
                return makeFeedbackEvent(
                    forRequest: request,
                    result: coreResult,
                    callback: callback
                )
            } else {
                throw SearchError.incorrectSearchResultForFeedback
            }
        }

        return makeFeedbackEvent(
            forRequest: request,
            result: nil,
            callback: callback
        )
    }

    func createUserLayer(_ layer: String, priority: Int32) -> CoreUserRecordsLayerProtocol {
        CoreSearchEngine.createUserLayer(forName: layer, priority: priority) as CoreUserRecordsLayer
    }

    func addUserLayer(_ layer: CoreUserRecordsLayerProtocol) {
        guard let layer = layer as? CoreUserRecordsLayer else {
            assertionFailure("Unexpected type of CoreUserRecordsLayerProtocol.")
            return
        }

        addUserLayer(for: layer)
    }

    func removeUserLayer(_ layer: CoreUserRecordsLayerProtocol) {
        guard let layer = layer as? CoreUserRecordsLayer else {
            assertionFailure("Unexpected type of CoreUserRecordsLayerProtocol.")
            return
        }

        removeUserLayer(for: layer)
    }

    func nextSearch(
        for result: CoreSearchResultProtocol,
        with originalRequest: CoreRequestOptions,
        callback: @escaping (CoreSearchResponseProtocol?) -> Void
    ) {
        if let coreResult = result as? CoreSearchResult {
            retrieve(forRequest: originalRequest, result: coreResult) { response in
                DispatchQueue.main.async {
                    callback(response)
                }
            }
        } else {
            // swiftlint:disable:next line_length
            assertionFailure(
                "Unexpected type of CoreSearchResultProtocol. Engine doesn't support nothing but CoreSearchResult"
            )
            DispatchQueue.main.async {
                callback(nil)
            }
        }
    }

    func batchResolve(
        results: [CoreSearchResultProtocol],
        with originalRequest: CoreRequestOptions,
        callback: @escaping (CoreSearchResponseProtocol?) -> Void
    ) {
        let searchResults = results.compactMap { $0 as? CoreSearchResult }
        assert(searchResults.count == results.count)

        retrieveBucket(forRequest: originalRequest, results: searchResults) { response in
            DispatchQueue.main.async {
                callback(response)
            }
        }
    }

    func onSelected(forRequest request: CoreRequestOptions, result: CoreSearchResultProtocol) {
        if let coreResult = result as? CoreSearchResult {
            // Skip `onSelected` call for non-final results
            if coreResult.center != nil {
                onSelected(forRequest: request, result: coreResult)
            }
        } else {
            // swiftlint:disable:next line_length
            assertionFailure(
                "Unexpected type of CoreSearchResultProtocol. Engine doesn't support nothing but CoreSearchResult"
            )
        }
    }

    func search(
        forQuery query: String,
        categories: [String],
        options: CoreSearchOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    ) {
        search(forQuery: query, categories: categories, options: options, callback: { response in
            DispatchQueue.main.async {
                completion(response)
            }
        })
    }

    func reverseGeocoding(
        for options: CoreReverseGeoOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    ) {
        reverseGeocoding(for: options, callback: { response in
            DispatchQueue.main.async {
                completion(response)
            }
        })
    }

    func searchOffline(
        query: String,
        categories: [String],
        options: CoreSearchOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    ) {
        searchOffline(forQuery: query, categories: categories, options: options) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    func getOfflineAddress(
        street: String,
        proximity: CLLocationCoordinate2D,
        radius: Double,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    ) {
        getAddressesOffline(forStreet: street, proximity: proximity, radiusM: radius) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    func reverseGeocodingOffline(
        for options: CoreReverseGeoOptions,
        completion: @escaping (CoreSearchResponseProtocol?) -> Void
    ) {
        reverseGeocodingOffline(for: options, callback: { response in
            DispatchQueue.main.async {
                completion(response)
            }
        })
    }
}
