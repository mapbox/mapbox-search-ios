// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxCoreSearch/MBXSFeedbackEventCallback.h>
#import <MapboxCoreSearch/MBXSSearchCallback.h>
#import <MapboxCoreSearch/MBXSVoidCallback.h>

@class MBXSCategoryOptions;
@class MBXSEngineOptions;
@class MBXSFeedbackProperties;
@class MBXSRequestOptions;
@class MBXSReverseGeoOptions;
@class MBXSSearchAddress;
@class MBXSSearchOptions;
@class MBXSSearchResponse;
@class MBXSSearchResult;
@class MBXSUserRecordsLayer;
@class MBXTileStore;
@class MBXTilesetDescriptor;
@protocol MBXSLocationProvider;
@protocol MBXSOfflineIndexObserver;

/**
 * Interface to make both Mapbox forward and reverse geocoding requests.
 * All operations with SearchEngine are dispatched on a shared task queue and require no additional synchronization on the caller side.
 * Recommended to create one instance for the whole app lifetime.
 *
 * SearchEngine operations are asynchronous. Operations that return a result do so via callbacks. The thread in
 * which a callback is called is not specified.
 */
NS_SWIFT_NAME(SearchEngine)
__attribute__((visibility ("default")))
@interface MBXSSearchEngine : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithOptions:(nonnull MBXSEngineOptions *)options
                               location:(nullable id<MBXSLocationProvider>)location;
/**
 * Adds a new offline search index observer to the SearchEngine.
 * Does nothing if the \a observer is already added thus allowing to register multiple observers only once each.
 * @note Due to bindgen, SearchEngine holds strong reference to the added observer preventing it
 * from destruction until the observer is removed using `removeOfflineIndexObserver()`. To avoid memory leak due to
 * cyclic dependency do not keep strong reference to the SearchEngine from the observer.
 *
 * @param observer The observer to be added.
 */
- (void)addOfflineIndexObserverForObserver:(nonnull id<MBXSOfflineIndexObserver>)observer;
/**
 * Removes an existing observer from the SearchEngine.
 * Does nothing if \a observer is not added to the SearchEngine.
 *
 * @param observer The observer to be removed.
 */
- (void)removeOfflineIndexObserverForObserver:(nonnull id<MBXSOfflineIndexObserver>)observer;
/**
 * Subscribes SearchEngine to the \a tileStore offline regions updates and registers all already loaded by
 * \a tileStore search tiles. Subsequent calls will unsubscribe actual \a tileStore and unregister related search
 * tiles before any operations with new one.
 *
 * @param tileStore Optional `common::TileStore` instance that might be parametrised using `common::TileStoreOptions`.
 * @param callback Invoked only once when all offline search index operations finished.
 */
- (void)setTileStoreForTileStore:(nullable MBXTileStore *)tileStore
                        callback:(nonnull MBXSVoidCallback)callback;
/**
 * Subscribes SearchEngine to the \a tileStore offline regions updates and registers all already loaded by
 * \a tileStore search tiles. Subsequent calls will unsubscribe actual \a tileStore and unregister related search
 * tiles before any operations with new one.
 *
 * @param tileStore Optional `common::TileStore` instance that might be parametrised using `common::TileStoreOptions`.
 */
- (void)setTileStoreForTileStore:(nullable MBXTileStore *)tileStore;
/**
 * Selects preferable tileset for offline search. If \a dataset or \a version is set, SearchEngine will try to
 * match appropriate tileset and use it. If several tilesets are suitable, the latest registered will be used.
 * Otherwise, "Offline regions not added" message will be set to the search result.
 * Index updates may change selected tileset if selected one is removed or new one, that matches to the requested
 * \a dataset and \a version, is added.
 *
 * @param dataset Optional preferable dataset or `null`.
 * @param version Optional preferable version or `null`.
 */
- (void)selectTilesetForDataset:(nullable NSString *)dataset
                        version:(nullable NSString *)version;
/**
 * Offline search based on offline search index.
 *
 * Each new search request cancels the previous one if it is still in progress. \sa RequestCancelled.
 *
 * @param query string to search.
 * @param categories Search categories. Currently ignored and presented only for API alignment with online search.
 * @param options Search options. Only `proximity`, `origin`, and `limit` parameters are used.
 * @param callback Invoked only once when an offline search has completed or an error has occurred.
 */
- (void)searchOfflineForQuery:(nonnull NSString *)query
                   categories:(nonnull NSArray<NSString *> *)categories
                      options:(nonnull MBXSSearchOptions *)options
                     callback:(nonnull MBXSSearchCallback)callback;
/**
 * Resolves geographic features that exist at that location based on offline search index.
 *
 * @param options Reverse geocoding search options. Only `point` parameter is used.
 * @param callback Invoked only once when an offline search has completed or an error has occurred.
 */
- (void)reverseGeocodingOfflineForOptions:(nonnull MBXSReverseGeoOptions *)options
                                 callback:(nonnull MBXSSearchCallback)callback;
/**
 * Offline fetch addresses around \a proximity point,
 * with \a radiusM radius in meters, matched with \a street street name.
 *
 * @param street Street name to search.
 * @param proximity Proximity point where to search.
 * @param radiusM Radius in meters around proximity point.
 * @param callback Invoked only once when an offline search has completed or an error has occurred.
 */
- (void)getAddressesOfflineForStreet:(nonnull NSString *)street
                           proximity:(CLLocationCoordinate2D)proximity
                             radiusM:(double)radiusM
                            callback:(nonnull MBXSSearchCallback)callback;
/**
 * Main (1st step) search function. \sa retrieve and \sa retrieveBucket for the second step.
 *
 * @param query Query to search. Can be empty.
 * @param categories List of categories. Can be empty.
 * @param options Search options.
 * @param callback Callback that is called with search results or when an error has occurred.
 *
 * @return Request id.
 */
- (uint64_t)searchForQuery:(nonnull NSString *)query
                categories:(nonnull NSArray<NSString *> *)categories
                   options:(nonnull MBXSSearchOptions *)options
                  callback:(nonnull MBXSSearchCallback)callback;
/**
 * Continue (next steps) search function.
 *
 * @param request Search request options.
 * @param result Search result returned by \sq search.
 * @param callback Callback that is called with retrieved results or when an error has occurred.
 *
 * @return Request id.
 */
- (uint64_t)retrieveForRequest:(nonnull MBXSRequestOptions *)request
                        result:(nonnull MBXSSearchResult *)result
                      callback:(nonnull MBXSSearchCallback)callback;
/**
 * Batch retrieve (nextSearch) for many results.
 *
 * @param request Search request options.
 * @param results Search results returned by \sa search.
 * @param callback Callback that is called with retrieved results or when an error has occurred.
 *
 * @return Request id.
 */
- (uint64_t)retrieveBucketForRequest:(nonnull MBXSRequestOptions *)request
                             results:(nonnull NSArray<MBXSSearchResult *> *)results
                            callback:(nonnull MBXSSearchCallback)callback;
/**
 * Call to notify that result was selected.
 * Causes ending current session, billing, telemetry event.
 *
 * @param request Search request options.
 * @param result Search result returned by \sa search.
 */
- (void)onSelectedForRequest:(nonnull MBXSRequestOptions *)request
                      result:(nonnull MBXSSearchResult *)result;
/**
 * Find intervals for the string \a name that was matched by input search \a query.
 *
 * @param name String name.
 * @param query Search query.
 * @return Array of intervals [i, i+1) for the \a name string.
 */
+ (nonnull NSArray<NSNumber *> *)getHighlightsForName:(nonnull NSString *)name
                                                query:(nonnull NSString *)query __attribute((ns_returns_retained));
/**
 * Formats `SearchAddress` to string. Useful as simple to_string operation for `SearchAddress` record.
 * Doesn't apply locale-specific address formatting rules.
 * Result pattern: "{houseNumber} {street},{neighborhood},{locality},{postcode},{place},{district},{region},{country}".
 * Example: "120 East 13th Street,East Village,Manhattan,10003,New York,New York County,New York,United States".
 *
 * @param address Search address to stringify.
 */
+ (nonnull NSString *)formatAddressForAddress:(nonnull MBXSSearchAddress *)address __attribute((ns_returns_retained));
/** [Deprecated] Creates a json feedback event. */
- (void)makeFeedbackEventForRequest:(nonnull MBXSRequestOptions *)request
                             result:(nullable MBXSSearchResult *)result
                           callback:(nonnull MBXSFeedbackEventCallback)callback;
/**
 * Sends "search.feedback" event with specified properties. Does nothing if `EngineOptions::sdkInformation` is not set.
 *
 * @param properties Feedback event properties.
 * @param response Search response associated with the feedback.
 * @param result Search result. Optional.
 */
- (void)sendFeedbackForProperties:(nonnull MBXSFeedbackProperties *)properties
                         response:(nonnull MBXSSearchResponse *)response
                           result:(nullable MBXSSearchResult *)result;
/**
 * Resolves geographic features that exist at that location.
 *
 * @param options Reverse geocoding request options.
 * @param callback Callback that is called with reverse geocoding results or when an error has occurred.
 *
 * @return Request id.
 */
- (uint64_t)reverseGeocodingForOptions:(nonnull MBXSReverseGeoOptions *)options
                              callback:(nonnull MBXSSearchCallback)callback;
/**
 * Cancel the request.
 *
 * @param requestId Id of the request to cancel.
 */
- (void)cancelForRequestId:(uint64_t)requestId;
/**
 * Creates a new user data layer.
 *
 * @param name     Layer name.
 * @param priority  Layer priority compared with other layers. Bigger is higher in result's list.
 * @note \a priority should be unique across all layers added to the same SearchEngine to avoid result's sorting ambiguity.
 */
+ (nonnull MBXSUserRecordsLayer *)createUserLayerForName:(nonnull NSString *)name
                                                priority:(int32_t)priority __attribute((ns_returns_retained));
/**
 * Registers \a layer to the SearchEngine.
 * Does nothing if the \a layer is already added thus allowing to register multiple layers only once each.
 *
 * @param layer User records layer to add.
 */
- (void)addUserLayerForLayer:(nonnull MBXSUserRecordsLayer *)layer;
/**
 * Unregisters \a layer from the SearchEngine.
 * Does nothing if \a layer is not added to the SearchEngine.
 *
 * @param layer User records layer to remove.
 */
- (void)removeUserLayerForLayer:(nonnull MBXSUserRecordsLayer *)layer;
/**
 * Creates `TilesetDescriptor` for offline search index that includes places data and addresses data.
 *
 * @param dataset The dataset the tile is referring to, e.g. `mbx-main`. The current valid dataset names are `mbx-main` and `here-main`.
 * @param version The version the tile is referring to, e.g. `2021_03_14-03_00_00`. Can be empty.
 * @return TilesetDescriptor that can pe passed to the `common::TileStore::loadTileRegion()`.
 */
+ (nonnull MBXTilesetDescriptor *)createTilesetDescriptorForDataset:(nonnull NSString *)dataset
                                                            version:(nonnull NSString *)version __attribute((ns_returns_retained));
/**
 * Creates `TilesetDescriptor` for offline search that covers only places index.
 * Using `createPlacesTilesetDescriptor()` will reduce amount of data loaded by `common::TileStore::loadTileRegion()`
 * (compared to the `createTilesetDescriptor()`) with decreasing the search quality (places only) at the same time.
 *
 * @param dataset The dataset the tile is referring to, e.g. `mbx-main`. The current valid dataset names are `mbx-main` and `here-main`.
 * @param version The version the tile is referring to, e.g. `2021_03_14-03_00_00`. Can be empty.
 * @return TilesetDescriptor that can pe passed to the `common::TileStore::loadTileRegion()`.
 */
+ (nonnull MBXTilesetDescriptor *)createPlacesTilesetDescriptorForDataset:(nonnull NSString *)dataset
                                                                  version:(nonnull NSString *)version __attribute((ns_returns_retained));

@end
