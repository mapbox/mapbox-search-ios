// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSImageInfo;
@class MBXSOpenHours;
@class MBXSParkingData;

/** POI Metadata fields. */
NS_SWIFT_NAME(ResultMetadata)
__attribute__((visibility ("default")))
@interface MBXSResultMetadata : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithReviewCount:(nullable NSNumber *)reviewCount
                                      phone:(nullable NSString *)phone
                                    website:(nullable NSString *)website
                                   avRating:(nullable NSNumber *)avRating
                                description:(nullable NSString *)description
                                  openHours:(nullable MBXSOpenHours *)openHours
                               primaryPhoto:(nullable NSArray<MBXSImageInfo *> *)primaryPhoto
                                 otherPhoto:(nullable NSArray<MBXSImageInfo *> *)otherPhoto
                                    cpsJson:(nullable NSString *)cpsJson
                                    parking:(nullable MBXSParkingData *)parking
                                       data:(nonnull NSDictionary<NSString *, NSString *> *)data;

/** Review count. */
@property (nonatomic, readonly, nullable) NSNumber *reviewCount;

/** Phone number. */
@property (nonatomic, readonly, nullable, copy) NSString *phone;

/** Website. */
@property (nonatomic, readonly, nullable, copy) NSString *website;

/** Average reviews rating. */
@property (nonatomic, readonly, nullable) NSNumber *avRating;

/** Long form detailed description for POI. */
@property (nonatomic, readonly, nullable, copy) NSString *description;

/** POI open hours. */
@property (nonatomic, readonly, nullable) MBXSOpenHours *openHours;

/** Primary photos array. */
@property (nonatomic, readonly, nullable, copy) NSArray<MBXSImageInfo *> *primaryPhoto;

/** Secondary photos array. */
@property (nonatomic, readonly, nullable, copy) NSArray<MBXSImageInfo *> *otherPhoto;

/**
 * CPS Specific Metadata. Contains custom data from third-party providers like POIs from Parkopedia.
 * Provided if additional API is enabled via SearchOptions::addonAPI.
 */
@property (nonatomic, readonly, nullable, copy) NSString *cpsJson;

/** Parking information for POIs. */
@property (nonatomic, readonly, nullable) MBXSParkingData *parking;

/** Dictionary with other metadata like "iso_3166_1" and "iso_3166_2" codes. */
@property (nonatomic, readonly, nonnull, copy) NSDictionary<NSString *, NSString *> *data;


@end
