// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Possible reverse modes enumeration for reverse geocoding. */
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXSReverseMode)
{
    /** Default mode that causes the closest feature to always be returned first. */
    MBXSReverseModeDistance,
    /** Making high-prominence features to be sorted higher than nearer, but lower-prominence features. */
    MBXSReverseModeScore
} NS_SWIFT_NAME(ReverseMode);
