// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * Fast distance calculator that uses WGS84 approximation for distances less than 200km and spherical for greater
 * distances. Expected error is 0.04%.
 *
 * \sa https://github.com/mapbox/cheap-ruler
 */
NS_SWIFT_NAME(DistanceCalculator)
__attribute__((visibility ("default")))
@interface MBXSDistanceCalculator : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithLat:(double)lat;
/**
 * Calculates distance in meters between \a p1 and \a p2 that store coordinates in [longitude, latitude] format.
 * Uses WGS84-based approximation for short distances (< 200km), or \ref distanceOnSphere for the long ones.
 */
- (double)distanceForP1:(CLLocationCoordinate2D)p1
                     p2:(CLLocationCoordinate2D)p2;
/** Lightweight distance in meters between \a p1 and \a p2 on spherical Earth. Expected error is 0.4%. */
+ (double)distanceOnSphereForP1:(CLLocationCoordinate2D)p1
                             p2:(CLLocationCoordinate2D)p2;

@end
