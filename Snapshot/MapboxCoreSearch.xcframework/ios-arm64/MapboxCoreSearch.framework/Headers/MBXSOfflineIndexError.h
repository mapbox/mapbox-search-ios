// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Offline Search index operation error type. */
NS_SWIFT_NAME(OfflineIndexError)
__attribute__((visibility ("default")))
@interface MBXSOfflineIndexError : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithRegion:(nonnull NSString *)region
                               dataset:(nonnull NSString *)dataset
                               version:(nonnull NSString *)version
                                  tile:(nonnull NSString *)tile
                               message:(nonnull NSString *)message;

/** The TileStore region with which the error is associated. */
@property (nonatomic, readonly, nonnull, copy) NSString *region;

/** Offline search index dataset. */
@property (nonatomic, readonly, nonnull, copy) NSString *dataset;

/** Offline search index version. */
@property (nonatomic, readonly, nonnull, copy) NSString *version;

/** Tile identifier with which the error is associated. Can be empty. */
@property (nonatomic, readonly, nonnull, copy) NSString *tile;

/** Error message. */
@property (nonatomic, readonly, nonnull, copy) NSString *message;


@end
