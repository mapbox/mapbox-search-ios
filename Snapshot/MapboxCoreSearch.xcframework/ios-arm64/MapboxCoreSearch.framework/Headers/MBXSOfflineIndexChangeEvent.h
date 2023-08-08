// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCoreSearch/MBXSOfflineIndexChangeEventType.h>

/** Offline Search index changed event. */
NS_SWIFT_NAME(OfflineIndexChangeEvent)
__attribute__((visibility ("default")))
@interface MBXSOfflineIndexChangeEvent : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithType:(MBXSOfflineIndexChangeEventType)type
                              region:(nonnull NSString *)region
                             dataset:(nonnull NSString *)dataset
                             version:(nonnull NSString *)version;

/** Event type that refers clarifies what kind of operation happened. */
@property (nonatomic, readonly) MBXSOfflineIndexChangeEventType type;

/** TileStore Offline Region identifier. */
@property (nonatomic, readonly, nonnull, copy) NSString *region;

/** Offline search index dataset. */
@property (nonatomic, readonly, nonnull, copy) NSString *dataset;

/** Offline search index version. */
@property (nonatomic, readonly, nonnull, copy) NSString *version;


@end
