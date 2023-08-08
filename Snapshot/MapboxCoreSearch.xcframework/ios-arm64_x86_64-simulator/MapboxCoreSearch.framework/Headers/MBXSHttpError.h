// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/**
 * HTTP Error indicates that HTTP request wasn't completed successfully. This
 *  error will only be reported for status codes not in range 200 >= .. < 300.
 */
NS_SWIFT_NAME(HttpError)
__attribute__((visibility ("default")))
@interface MBXSHttpError : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithHttpCode:(int32_t)httpCode
                                 message:(nonnull NSString *)message;

/** Server HTTP response status code. */
@property (nonatomic, readonly) int32_t httpCode;

/** Server HTTP response status message. */
@property (nonatomic, readonly, nonnull, copy) NSString *message;


@end
