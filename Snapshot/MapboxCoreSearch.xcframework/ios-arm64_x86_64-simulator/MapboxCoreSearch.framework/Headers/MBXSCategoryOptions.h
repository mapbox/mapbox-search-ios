// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Options for SearchEngine::listCategories() request. */
NS_SWIFT_NAME(CategoryOptions)
__attribute__((visibility ("default")))
@interface MBXSCategoryOptions : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithLanguage:(nonnull NSString *)language
                                   limit:(nullable NSNumber *)limit;

/** ISO language code. */
@property (nonatomic, readonly, nonnull, copy) NSString *language;

/**
 * Limit the number of results to return if set.
 * May cause HTTP 400 Bad Request error if specified limit is not supported by the backend.
 */
@property (nonatomic, readonly, nullable) NSNumber *limit;


@end
