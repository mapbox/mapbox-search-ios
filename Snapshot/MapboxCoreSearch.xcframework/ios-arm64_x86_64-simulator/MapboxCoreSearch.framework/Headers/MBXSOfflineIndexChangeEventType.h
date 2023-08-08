// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Offline Search index update type. */
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXSOfflineIndexChangeEventType)
{
    /** A new index data has been added (registered) to the Offline Search. */
    MBXSOfflineIndexChangeEventTypeAdded,
    /** Existing index data has been updated. */
    MBXSOfflineIndexChangeEventTypeUpdated,
    /** Existing index data has been removed (unregistered) from the Offline Search. */
    MBXSOfflineIndexChangeEventTypeRemoved
} NS_SWIFT_NAME(OfflineIndexChangeEventType);
