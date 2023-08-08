// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/** Bounding box, aligned by latitude and longitude. */
NS_SWIFT_NAME(LonLatBBox)
__attribute__((visibility ("default")))
@interface MBXSLonLatBBox : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithMin:(CLLocationCoordinate2D)min
                                max:(CLLocationCoordinate2D)max;

/** Left lower point. */
@property (nonatomic, readonly) CLLocationCoordinate2D min;

/** Right upper point. */
@property (nonatomic, readonly) CLLocationCoordinate2D max;


@end
