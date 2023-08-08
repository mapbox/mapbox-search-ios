// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSOfflineIndexChangeEvent;
@class MBXSOfflineIndexError;

/** Observer for notifications about changes in offline search index. */
NS_SWIFT_NAME(OfflineIndexObserver)
@protocol MBXSOfflineIndexObserver
/**
 * Called whenever the offline search index changes.
 * @note Single TileStore region update may cause multiple `onIndexChanged()` invocations because a single
 * `TileStore::loadTileRegion()` update may update the tileset descriptors for an existing offline region removing
 * old ones and adding new ones.
 */
- (void)onIndexChangedForEvent:(nonnull MBXSOfflineIndexChangeEvent *)event;
/** Called whenever an error arises during index update. */
- (void)onErrorForError:(nonnull MBXSOfflineIndexError *)error;
@end
