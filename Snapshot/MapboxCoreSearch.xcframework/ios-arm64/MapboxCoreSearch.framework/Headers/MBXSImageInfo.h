// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Image of POI. */
NS_SWIFT_NAME(ImageInfo)
__attribute__((visibility ("default")))
@interface MBXSImageInfo : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithUrl:(nonnull NSString *)url
                              width:(uint32_t)width
                             height:(uint32_t)height;

/** URL of the image. */
@property (nonatomic, readonly, nonnull, copy) NSString *url;

/** Width in pixels of the image. */
@property (nonatomic, readonly) uint32_t width;

/** Height in pixels of the image. */
@property (nonatomic, readonly) uint32_t height;


@end
