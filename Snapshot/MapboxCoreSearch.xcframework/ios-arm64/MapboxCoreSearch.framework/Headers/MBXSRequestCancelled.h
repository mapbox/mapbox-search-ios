// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * Request Cancelled is reported for the search requests that have been cancelled and will not
 *  be completed. This doesn't indicate that the error occurred while processing the request, but
 *  that the request became obsolete and no longer requires completion.
 *
 *  The most common reason why that could happen is when using debounce option for the requests.
 *  When a new search request is created while the previous one is still in debounce interval, then
 *  the previous request will be cancelled and its results will be set to RequestCancelled.
 */
NS_SWIFT_NAME(RequestCancelled)
__attribute__((visibility ("default")))
@interface MBXSRequestCancelled : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithReason:(nonnull NSString *)reason;

/** Reason why the request was cancelled. */
@property (nonatomic, readonly, nonnull, copy) NSString *reason;


@end
