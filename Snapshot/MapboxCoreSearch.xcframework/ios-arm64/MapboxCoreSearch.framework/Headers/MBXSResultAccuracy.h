// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * A point accuracy metric for the returned search result.
 * \sa https://docs.mapbox.com/api/search/geocoding/#point-accuracy-for-address-features
 */
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXSResultAccuracy)
{
    /** Result is a known address point but has no specific accuracy. */
    MBXSResultAccuracyPoint,
    /** Result is for a specific building/entrance. */
    MBXSResultAccuracyRooftop,
    /** Result is derived from a parcel centroid. */
    MBXSResultAccuracyParcel,
    /** Result has been interpolated from an address range. */
    MBXSResultAccuracyInterpolated,
    /** Result is for a block or intersection. */
    MBXSResultAccuracyIntersection,
    /** Result is an approximate location. */
    MBXSResultAccuracyApproximate,
    /** Result is a street centroid. */
    MBXSResultAccuracyStreet
} NS_SWIFT_NAME(ResultAccuracy);

NSString* MBXSResultAccuracyToString(MBXSResultAccuracy result_accuracy);
