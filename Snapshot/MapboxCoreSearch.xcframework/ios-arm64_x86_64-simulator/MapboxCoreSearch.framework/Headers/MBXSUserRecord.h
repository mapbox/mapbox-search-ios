// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxCoreSearch/MBXSResultType.h>

@class MBXSSearchAddress;

/**
 * User record that can be indexed by SearchEngine and added to the search results if matched by query or category.
 * Can be used for Hisotry or Favorite functionality implementation or to mix in custom data.
 */
NS_SWIFT_NAME(UserRecord)
__attribute__((visibility ("default")))
@interface MBXSUserRecord : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithId:(nonnull NSString *)id_
                              name:(nonnull NSString *)name
                            center:(nullable CLLocation *)center
                           address:(nullable MBXSSearchAddress *)address
                        categories:(nullable NSArray<NSString *> *)categories
                       indexTokens:(nullable NSArray<NSString *> *)indexTokens;

- (nonnull instancetype)initWithId:(nonnull NSString *)id_
                              name:(nonnull NSString *)name
                            center:(nullable CLLocation *)center
                           address:(nullable MBXSSearchAddress *)address
                        categories:(nullable NSArray<NSString *> *)categories
                       indexTokens:(nullable NSArray<NSString *> *)indexTokens
                          fromType:(MBXSResultType)fromType;

/** User Record id. Unique for single layer. */
@property (nonatomic, readonly, nonnull, copy) NSString *id;

/** User Record name. */
@property (nonatomic, readonly, nonnull, copy) NSString *name;

/** Associated position in [longitude, latitude] format. Important for matching(merging) with server results. */
@property (nonatomic, readonly, nullable) CLLocation *center;

/** Associated address entry. */
@property (nonatomic, readonly, nullable) MBXSSearchAddress *address;

/** List of categories to match results during categories search. */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *categories;

/**
 * Additional tokens array to be indexed for search by query.
 * User can pass address, description, etc, splitted on tokens for matching.
 */
@property (nonatomic, readonly, nullable, copy) NSArray<NSString *> *indexTokens;

/** Set this type to filter records during search by SearchOptions.types. */
@property (nonatomic, readonly) MBXSResultType fromType;


@end
