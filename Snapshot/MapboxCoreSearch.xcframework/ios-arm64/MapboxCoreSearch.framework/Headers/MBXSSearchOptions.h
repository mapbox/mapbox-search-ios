// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxCoreSearch/MBXSQueryType.h>

@class MBXSLonLatBBox;

/**
 * Interface to hold Search options to access Mapbox forward, reverse, batch forward and batch reverse geocoding.
 *
 * \sa https://github.com/mapbox/search-federation/blob/main/api_v1.yaml
 */
NS_SWIFT_NAME(SearchOptions)
__attribute__((visibility ("default")))
@interface MBXSSearchOptions : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithProximity:(nullable CLLocation *)proximity
                                   origin:(nullable CLLocation *)origin
                               navProfile:(nullable NSString *)navProfile
                                  etaType:(nullable NSString *)etaType
                                     bbox:(nullable MBXSLonLatBBox *)bbox
                                countries:(nullable NSArray<NSString *> *)countries
                               fuzzyMatch:(nullable NSNumber *)fuzzyMatch
                                 language:(nullable NSArray<NSString *> *)language
                                    limit:(nullable NSNumber *)limit
                                    types:(nullable NSArray<NSNumber *> *)types
                      urDistanceThreshold:(nullable NSNumber *)urDistanceThreshold
                          requestDebounce:(nullable NSNumber *)requestDebounce
                                    route:(nullable NSArray<CLLocation *> *)route
                                  sarType:(nullable NSString *)sarType
                            timeDeviation:(nullable NSNumber *)timeDeviation
                                 addonAPI:(nullable NSDictionary<NSString *, NSString *> *)addonAPI;

- (nonnull instancetype)initWithProximity:(nullable CLLocation *)proximity
                                   origin:(nullable CLLocation *)origin
                               navProfile:(nullable NSString *)navProfile
                                  etaType:(nullable NSString *)etaType
                                     bbox:(nullable MBXSLonLatBBox *)bbox
                                countries:(nullable NSArray<NSString *> *)countries
                               fuzzyMatch:(nullable NSNumber *)fuzzyMatch
                                 language:(nullable NSArray<NSString *> *)language
                                    limit:(nullable NSNumber *)limit
                                    types:(nullable NSArray<NSNumber *> *)types
                                 ignoreUR:(BOOL)ignoreUR
                      urDistanceThreshold:(nullable NSNumber *)urDistanceThreshold
                          requestDebounce:(nullable NSNumber *)requestDebounce
                                    route:(nullable NSArray<CLLocation *> *)route
                                  sarType:(nullable NSString *)sarType
                            timeDeviation:(nullable NSNumber *)timeDeviation
                                 addonAPI:(nullable NSDictionary<NSString *, NSString *> *)addonAPI;

/** Set the location to bias local results. */
@property (nonatomic, readonly, nullable) CLLocation *proximity;

/** Set the location for distance estimate. */
@property (nonatomic, readonly, nullable) CLLocation *origin;

/** Set the navigation profile for distance estimate. Applicable one of ["driving", "walking", "cycling"]. */
@property (nonatomic, readonly, nullable, copy) NSString *navProfile;

/**
 * Set to "navigation" to indicate that the caller intends to perform a **higher cost** navigation ETA estimate.
 * This along with \a origin and \a navProfile is required in order receive ETA estimates.
 */
@property (nonatomic, readonly, nullable, copy) NSString *etaType;

/** Limit results to only those contained within the supplied bounding box. */
@property (nonatomic, readonly, nullable) MBXSLonLatBBox *bbox;

/**
 * Set one or more countries to limit results to one or more countries.
 * Permitted values are ISO 3166 alpha 2 country codes like US, GB, DE, BY.
 */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *countries;

/**
 * Specify whether the Geocoding API should attempt approximate.
 * For example, the default setting might return Washington, DC for
 * a query of wahsington, even though the query was misspelled.
 *
 * @note Ignored for ApiType::SBS.
 */
@property (nonatomic, readonly, nullable) NSNumber *fuzzyMatch;

/**
 * Specify the user’s language(s).
 * This parameter controls the language of the text supplied in responses,
 * and also affects result scoring, with results matching the user’s query in
 * the requested language being preferred over results that match in another language.
 *
 * @note Multiple languages are only supported by Geocoding(V5) back end. If more than 1 language is set for SBS,
 * only the first one (with index 0) will be used and the rest will be silently ignored. Applies "en" by default.
 */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *language;

/**
 * Limit the number of results (both server and UserRecords) to return if set. By default, no limit is applied and
 * backend uses it's own limit (usually 10) for server results and no limit is used for UserRecords.
 * May cause HTTP 400 Bad Request error if specified limit is not supported by the backend.
 */
@property (nonatomic, readonly, nullable) NSNumber *limit;

/**
 * Filter results to include only a subset (one or more) of the available feature types.
 * All query types except 'QueryType::Poi' are ignored for category search.
 */
@property (nonatomic, readonly, nullable, copy) NSArray<NSNumber *> *types;

/** Ignore UserRecords for this search. */
@property (nonatomic, readonly) BOOL ignoreUR;

/** Distance threshold from the \a proximity in meters to filter UserRecord for this search. */
@property (nonatomic, readonly, nullable) NSNumber *urDistanceThreshold;

/** Debounce in milliseconds before sending request on server. Reduces server spam on query quick typing. */
@property (nonatomic, readonly, nullable) NSNumber *requestDebounce;

/**
 * A polyline, describing the route to be used for searching.
 * @note Required to perform a search along a route.
 */
@property (nonatomic, readonly, nullable, copy) NSArray<CLLocation *> *route;

/**
 * Set to "isochrone" to indicate that the caller intends to perform a **higher cost** search along a route.
 * This is and route are required to perform a search along a route.
 */
@property (nonatomic, readonly, nullable, copy) NSString *sarType;

/** Maximum detour in estimated minutes from route. */
@property (nonatomic, readonly, nullable) NSNumber *timeDeviation;

/**
 * Additional HTTP request options to enable interaction with third-party API on the backend side.
 * SBS example: set { "cps_parking_type", "OFF_STREET" } and perform "parking_lot" category search for Parkopedia.
 * Geocoding example: set { "routing", "true" } and perform search to get SearchResult::routablePoints.
 * @note May require special access token.
 */
@property (nonatomic, readonly, nullable, copy) NSDictionary<NSString *, NSString *> *addonAPI;


@end
