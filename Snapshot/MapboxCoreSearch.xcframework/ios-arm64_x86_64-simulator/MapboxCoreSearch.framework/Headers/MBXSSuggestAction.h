// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Suggest action that may refer to '/retrieve' for suggest items and to '/suggest' for spelling correction. */
NS_SWIFT_NAME(SuggestAction)
__attribute__((visibility ("default")))
@interface MBXSSuggestAction : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithEndpoint:(nonnull NSString *)endpoint
                                    path:(nonnull NSString *)path
                                   query:(nullable NSString *)query
                                    body:(nullable NSData *)body
                        multiRetrievable:(BOOL)multiRetrievable;

@property (nonatomic, readonly, nonnull, copy) NSString *endpoint;
@property (nonatomic, readonly, nonnull, copy) NSString *path;
@property (nonatomic, readonly, nullable, copy) NSString *query;
@property (nonatomic, readonly, nullable) NSData *body;
@property (nonatomic, readonly) BOOL multiRetrievable;

@end
