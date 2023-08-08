// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Parking information for POIs. */
NS_SWIFT_NAME(ParkingData)
__attribute__((visibility ("default")))
@interface MBXSParkingData : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithCapacity:(uint32_t)capacity
                         forDisabilities:(uint32_t)forDisabilities;

/** Number of parking spots. */
@property (nonatomic, readonly) uint32_t capacity;

/** Number of spots for persons with disabilities. */
@property (nonatomic, readonly) uint32_t forDisabilities;


@end
