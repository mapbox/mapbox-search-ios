// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Address region information. */
NS_SWIFT_NAME(SearchAddressRegion)
__attribute__((visibility ("default")))
@interface MBXSSearchAddressRegion : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithName:(nonnull NSString *)name
                          regionCode:(nullable NSString *)regionCode
                      regionCodeFull:(nullable NSString *)regionCodeFull;

/** Region name. */
@property (nonatomic, readonly, nonnull, copy) NSString *name;

/** Region code. */
@property (nonatomic, readonly, nullable, copy) NSString *regionCode;

/** iso_3166_2 region code. */
@property (nonatomic, readonly, nullable, copy) NSString *regionCodeFull;


- (BOOL)isEqualToSearchAddressRegion:(nonnull MBXSSearchAddressRegion *)other;

@end
