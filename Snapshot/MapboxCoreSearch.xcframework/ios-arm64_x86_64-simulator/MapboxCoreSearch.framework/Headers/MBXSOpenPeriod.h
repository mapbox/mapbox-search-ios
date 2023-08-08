// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * Time period of time where the POI is open.
 * Times are in local POI time zone. 00:00 represents midnight in morning, 24:00 represents midnight at night.
 */
NS_SWIFT_NAME(OpenPeriod)
__attribute__((visibility ("default")))
@interface MBXSOpenPeriod : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithOpenD:(uint8_t)openD
                                openH:(uint8_t)openH
                                openM:(uint8_t)openM
                              closedD:(uint8_t)closedD
                              closedH:(uint8_t)closedH
                              closedM:(uint8_t)closedM;

/** Day of Week - 0=Monday, 1=Tuesday. Possible values are [0,1,2,3,4,5,6]. */
@property (nonatomic, readonly) uint8_t openD;

/** Hour, 0-24. */
@property (nonatomic, readonly) uint8_t openH;

/** Minute 0-59. */
@property (nonatomic, readonly) uint8_t openM;

/** Day of Week - 0=Monday, 1=Tuesday. Possible values are [0,1,2,3,4,5,6]. */
@property (nonatomic, readonly) uint8_t closedD;

/** Hour, 0-24. */
@property (nonatomic, readonly) uint8_t closedH;

/** Minute 0-59. */
@property (nonatomic, readonly) uint8_t closedM;


@end
