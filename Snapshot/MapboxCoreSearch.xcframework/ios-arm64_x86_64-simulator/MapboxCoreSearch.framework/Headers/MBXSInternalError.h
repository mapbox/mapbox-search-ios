// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Internal Error indicates the inability to process the search request. */
NS_SWIFT_NAME(InternalError)
__attribute__((visibility ("default")))
@interface MBXSInternalError : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithMessage:(nonnull NSString *)message;

/** Internal error message. */
@property (nonatomic, readonly, nonnull, copy) NSString *message;


@end
