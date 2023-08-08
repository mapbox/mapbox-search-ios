// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSUserRecord;

/**
 * The User Records collection, that indexes all added records.
 * All operations with layer are dispatched on a shared task queue and require no additional synchronization on the caller side.
 * Should be created by SearchEngine::createUserLayer() static method.
 */
NS_SWIFT_NAME(UserRecordsLayer)
__attribute__((visibility ("default")))
@interface MBXSUserRecordsLayer : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

/** Layer name. Will be displayed in SearchResult::layer for each matched record. */
- (nonnull NSString *)name __attribute((ns_returns_retained));
/** Adds a new record or update existing one matched by id. */
- (void)upsertForRecord:(nonnull MBXSUserRecord *)record;
/** Adds new records or update existing ones matched by ids. */
- (void)upsertMultiForRecord:(nonnull NSArray<MBXSUserRecord *> *)record;
/** Removes an existing record matched by \a id. */
- (void)removeForId:(nonnull NSString *)id_;
/** Removes multiple records matched by \a ids. */
- (void)removeMultiForIds:(nonnull NSArray<NSString *> *)ids;
/** Resets UserRecordsLayer instance state by removing all records. */
- (void)clear;

@end
