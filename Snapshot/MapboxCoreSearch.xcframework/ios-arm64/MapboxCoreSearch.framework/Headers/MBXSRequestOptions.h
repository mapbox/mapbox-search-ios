// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSSearchOptions;

/** Internal search request options. */
NS_SWIFT_NAME(RequestOptions)
__attribute__((visibility ("default")))
@interface MBXSRequestOptions : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithQuery:(nonnull NSString *)query
                             endpoint:(nonnull NSString *)endpoint
                              options:(nonnull MBXSSearchOptions *)options
                   proximityRewritten:(BOOL)proximityRewritten
                      originRewritten:(BOOL)originRewritten
                            sessionID:(nonnull NSString *)sessionID;

/**
 * Can be one of: \n
 * - user input query, endpoint = "suggest" \n
 * - user input categories comma separated, endpoint = "category" \n
 * - user input coordinates for reverse geocoding, endpoint = "reverse" \n
 */
@property (nonatomic, readonly, nonnull, copy) NSString *query;

/** One of { "suggest", "category", "reverse" }. */
@property (nonatomic, readonly, nonnull, copy) NSString *endpoint;

/** Associated search options. */
@property (nonatomic, readonly, nonnull) MBXSSearchOptions *options;

/** Flag that options.proximity was rewritten by SearchEngine based on LocationProvider data. */
@property (nonatomic, readonly) BOOL proximityRewritten;

/** Flag that options.origin was rewritten by SearchEngine based on LocationProvider data. */
@property (nonatomic, readonly) BOOL originRewritten;

/** Session ID that groups a series of requests for billing purposes. */
@property (nonatomic, readonly, nonnull, copy) NSString *sessionID;


@end
