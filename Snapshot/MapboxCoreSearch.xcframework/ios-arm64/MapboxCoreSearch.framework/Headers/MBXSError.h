// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSConnectionError;
@class MBXSHttpError;
@class MBXSInternalError;
@class MBXSRequestCancelled;
// NOLINTNEXTLINE(modernize-use-using)
typedef NS_ENUM(NSInteger, MBXSErrorType)
{
    MBXSErrorTypeConnectionError,
    MBXSErrorTypeHttpError,
    MBXSErrorTypeInternalError,
    MBXSErrorTypeRequestCancelled
} NS_SWIFT_NAME(ErrorType);

/** Variant type that combines all possible errors for Search SDK API. */
NS_SWIFT_NAME(Error)
__attribute__((visibility ("default")))
@interface MBXSError : NSObject

- (nonnull instancetype)initWithValue:(nonnull id)value __attribute__((deprecated("Please use: '+from{TypeName}:' instead.")));

+ (nonnull instancetype)fromConnectionError:(nonnull MBXSConnectionError *)value;
+ (nonnull instancetype)fromHttpError:(nonnull MBXSHttpError *)value;
+ (nonnull instancetype)fromInternalError:(nonnull MBXSInternalError *)value;
+ (nonnull instancetype)fromRequestCancelled:(nonnull MBXSRequestCancelled *)value;

- (BOOL)isConnectionError;
- (BOOL)isHttpError;
- (BOOL)isInternalError;
- (BOOL)isRequestCancelled;

- (nonnull MBXSConnectionError *)getConnectionError __attribute((ns_returns_retained));
- (nonnull MBXSHttpError *)getHttpError __attribute((ns_returns_retained));
- (nonnull MBXSInternalError *)getInternalError __attribute((ns_returns_retained));
- (nonnull MBXSRequestCancelled *)getRequestCancelled __attribute((ns_returns_retained));

@property (nonatomic, nonnull) id value;

@property (nonatomic, readonly) MBXSErrorType type;

@end
