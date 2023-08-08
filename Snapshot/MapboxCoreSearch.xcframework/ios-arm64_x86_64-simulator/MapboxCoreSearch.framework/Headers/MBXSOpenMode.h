// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** The type of hours available for the POI. */
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXSOpenMode)
{
    /** The POI is always open. */
    MBXSOpenModeAlwaysOpen,
    /** The POI is temporarily closed. */
    MBXSOpenModeTemporarilyClosed,
    /** The POI is permanently closed. */
    MBXSOpenModePermanentlyClosed,
    /** The POI is opened in time periods listed in OpenHours::periods. */
    MBXSOpenModeScheduled
} NS_SWIFT_NAME(OpenMode);
