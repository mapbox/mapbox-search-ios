// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxCoreSearch/MBXSResultAccuracy.h>
#import <MapboxCoreSearch/MBXSResultType.h>

@class MBXSResultMetadata;
@class MBXSRoutablePoint;
@class MBXSSearchAddress;
@class MBXSSuggestAction;

/** Search result. */
NS_SWIFT_NAME(SearchResult)
__attribute__((visibility ("default")))
@interface MBXSSearchResult : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithId:(nonnull NSString *)id_
                             types:(nonnull NSArray<NSNumber *> *)types
                             names:(nonnull NSArray<NSString *> *)names
                         languages:(nonnull NSArray<NSString *> *)languages
                         addresses:(nullable NSArray<MBXSSearchAddress *> *)addresses
                      descrAddress:(nullable NSString *)descrAddress
                      matchingName:(nullable NSString *)matchingName
                       fullAddress:(nullable NSString *)fullAddress
                          distance:(nullable NSNumber *)distance
                               eta:(nullable NSNumber *)eta
                            center:(nullable CLLocation *)center
                          accuracy:(nullable NSNumber *)accuracy
                    routablePoints:(nullable NSArray<MBXSRoutablePoint *> *)routablePoints
                        categories:(nullable NSArray<NSString *> *)categories
                       categoryIDs:(nullable NSArray<NSString *> *)categoryIDs
                             brand:(nullable NSArray<NSString *> *)brand
                           brandID:(nullable NSString *)brandID
                              icon:(nullable NSString *)icon
                          metadata:(nullable MBXSResultMetadata *)metadata
                       externalIDs:(nullable NSDictionary<NSString *, NSString *> *)externalIDs
                             layer:(nullable NSString *)layer
                      userRecordID:(nullable NSString *)userRecordID
                userRecordPriority:(int32_t)userRecordPriority
                            action:(nullable MBXSSuggestAction *)action
                       serverIndex:(nullable NSNumber *)serverIndex;

/** Result id. */
@property (nonatomic, readonly, nonnull, copy) NSString *id;

/** The types of the result. */
@property (nonatomic, readonly, nonnull, copy) NSArray<NSNumber *> *types;

/** Names matched to the \a languages array. */
@property (nonatomic, readonly, nonnull, copy) NSArray<NSString *> *names;

/** Array of languages in which the result is presented. */
@property (nonatomic, readonly, nonnull, copy) NSArray<NSString *> *languages;

/** Addresses matched to the \a languages array. */
@property (nonatomic, readonly, nullable, copy) NSArray<MBXSSearchAddress *> *addresses;

/** Additional details, such as city and state for addresses. */
@property (nonatomic, readonly, nullable, copy) NSString *descrAddress;

/** The feature name, as matched by the search algorithm. */
@property (nonatomic, readonly, nullable, copy) NSString *matchingName;

/** Full address including house number, street, city, country. */
@property (nonatomic, readonly, nullable, copy) NSString *fullAddress;

/** An approximate distance to the origin location, in meters. */
@property (nonatomic, readonly, nullable) NSNumber *distance;

/** The estimated time of arrival from the feature to the origin point, in minutes. */
@property (nonatomic, readonly, nullable) NSNumber *eta;

/** The coordinates of the feature’s center in [longitude, latitude] format. */
@property (nonatomic, readonly, nullable) CLLocation *center;

/** A point accuracy metric. */
@property (nonatomic, readonly, nullable) NSNumber *accuracy;

/** Routable points for the feature. */
@property (nonatomic, readonly, nullable, copy) NSArray<MBXSRoutablePoint *> *routablePoints;

/** The list of categories to which the result belongs. */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *categories;

/** The list of category ids to which the result belongs. */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *categoryIDs;

/** Brand name. */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *brand;

/** Brand id. */
@property (nonatomic, readonly, nullable, copy) NSString *brandID;

/**
 * The name of a suggested Maki icon to visualize a POI feature based on its category.
 * \sa https://labs.mapbox.com/maki-icons/.
 */
@property (nonatomic, readonly, nullable, copy) NSString *icon;

/** Result metadata. */
@property (nonatomic, readonly, nullable) MBXSResultMetadata *metadata;

/** {provider: id} map of external ids. */
@property (nonatomic, readonly, nullable, copy) NSDictionary<NSString *, NSString *> *externalIDs;

/** UserRecordsLayer name if result matched from it. */
@property (nonatomic, readonly, nullable, copy) NSString *layer;

/** Matched UserRecord id. */
@property (nonatomic, readonly, nullable, copy) NSString *userRecordID;

/** UserRecordLayer priority if result matched from it. */
@property (nonatomic, readonly) int32_t userRecordPriority;

/**
 * Available action to take from a given suggestion
 * Note: Private fields.
 */
@property (nonatomic, readonly, nullable) MBXSSuggestAction *action;

/**
 * Result's index (order) in response from the server. Important for 'search.select' telemetry event.
 * Presented as separate field to remember original ranking (from the server) because the search results
 * can be reordered if the search result matches any UserRecord and thus moved to the top.
 */
@property (nonatomic, readonly, nullable) NSNumber *serverIndex;


@end
