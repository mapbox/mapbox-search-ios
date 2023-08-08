// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxCoreSearch/MBXSQueryType.h>
#import <MapboxCoreSearch/MBXSReverseMode.h>

NS_SWIFT_NAME(ReverseGeoOptions)
__attribute__((visibility ("default")))
@interface MBXSReverseGeoOptions : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithPoint:(CLLocationCoordinate2D)point
                          reverseMode:(nullable NSNumber *)reverseMode
                            countries:(nullable NSArray<NSString *> *)countries
                             language:(nullable NSArray<NSString *> *)language
                                limit:(nullable NSNumber *)limit
                                types:(nullable NSArray<NSNumber *> *)types;

/** A [longitude, latitude] pair that specifies the location being queried. */
@property (nonatomic, readonly) CLLocationCoordinate2D point;

/**
 * Decides how results are sorted.
 * Options are distance (default), which causes the closest feature to always be returned first,
 * and score, which allows high-prominence features to be sorted higher than nearer, lower-prominence features.
 *
 * @note Ignored for ApiType::SBS and ApiType::Autofill.
 */
@property (nonatomic, readonly, nullable) NSNumber *reverseMode;

/**
 * Set one or more countries to limit results to one or more countries.
 * Permitted values are ISO 3166 alpha 2 country codes like US, GB, DE, BY.
 *
 * @note Ignored for ApiType::SBS and ApiType::Autofill.
 */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *countries;

/**
 * Specify the user’s language(s) by ISO language code(s).
 * This parameter controls the language of the text supplied in responses,
 * and also affects result scoring, with results matching the user’s query in
 * the requested language being preferred over results that match in another language.
 *
 * @note Multiple languages are only supported by Geocoding(V5) back end. If more than 1 language is set for SBS
 * or for Autofill, only the first one (with index 0) will be used and the rest will be silently ignored.
 * Applies "en" by default.
 */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *language;

/**
 * Limit the number of results to return if set. By default, backend uses it's own default limit (usually 10).
 * May cause HTTP 400 Bad Request error if specified limit is not supported by the backend.
 *
 * @note Ignored for ApiType::Autofill. Only 1 result is returned.
 */
@property (nonatomic, readonly, nullable) NSNumber *limit;

/** Filter results to include only a subset (one or more) of the available feature types. */
@property (nonatomic, readonly, nullable, copy) NSArray<NSNumber *> *types;


@end
