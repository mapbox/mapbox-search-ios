// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * Connection Error indicates that connection establishment was failed for some reason.
 * For example, requested endpoint is unavailable, request timeout is occurred or bad/illegal symbol is used in URL.
 */
NS_SWIFT_NAME(ConnectionError)
__attribute__((visibility ("default")))
@interface MBXSConnectionError : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithMessage:(nonnull NSString *)message;

/** Connection error message. */
@property (nonatomic, readonly, nonnull, copy) NSString *message;


@end
