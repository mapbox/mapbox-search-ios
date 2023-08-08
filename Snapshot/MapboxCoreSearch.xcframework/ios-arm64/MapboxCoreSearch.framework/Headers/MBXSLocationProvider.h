// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class MBXSLonLatBBox;

/** Interface for platform-specific location provider. */
NS_SWIFT_NAME(LocationProvider)
@protocol MBXSLocationProvider
/**
 * Provides current device's location.
 *
 * This method is invoked
 * - if SearchOptions::bbox is not provided and (SearchOptions::proximity is not provided or invalid) to define
 * requests proximity,
 * - if SearchOptions::origin is not provided or invalid to define requests origin,
 * - to fill 'lng' & 'lat' properties in the telemetry event template created by SearchEngine::createEventTemplate().
 *
 * Note: LonLat point is considered as invalid if its |lon| > 180 or |lat| > 90.
 */
- (nullable CLLocation *)getLocation;
/**
 * Provides currently viewed area of map to fill 'mapCenterLng', 'mapCenterLat' and 'mapZoom' properties
 * in the telemetry event template created by SearchEngine::createEventTemplate().
 */
- (nullable MBXSLonLatBBox *)getViewport;
@end
