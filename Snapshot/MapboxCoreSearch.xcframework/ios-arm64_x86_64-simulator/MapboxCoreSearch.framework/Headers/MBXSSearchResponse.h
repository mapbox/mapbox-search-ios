// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
@class MBXExpected<__covariant Value, __covariant Error>;

@class MBXSError;
@class MBXSRequestOptions;
@class MBXSSearchResult;

/** Search response object that can be treated as 'expected'. */
NS_SWIFT_NAME(SearchResponse)
__attribute__((visibility ("default")))
@interface MBXSSearchResponse : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;


/** Request options. */
@property (nonatomic, readonly, nonnull) MBXSRequestOptions *request;

/** Service response identifier. Please include this information when reporting issues to Mapbox. */
@property (nonatomic, readonly, nonnull, copy) NSString *responseUUID;


@end
