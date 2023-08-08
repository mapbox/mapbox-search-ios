// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/** Auxiliary point to build route to the search result. */
NS_SWIFT_NAME(RoutablePoint)
__attribute__((visibility ("default")))
@interface MBXSRoutablePoint : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithPoint:(CLLocationCoordinate2D)point
                                 name:(nonnull NSString *)name;

/** Routable point location in [longitude, latitude] format. */
@property (nonatomic, readonly) CLLocationCoordinate2D point;

/** Routable point name like "Entrance #1". */
@property (nonatomic, readonly, nonnull, copy) NSString *name;


@end
