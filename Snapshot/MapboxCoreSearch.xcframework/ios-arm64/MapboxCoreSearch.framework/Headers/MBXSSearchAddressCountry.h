// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** Address country information. */
NS_SWIFT_NAME(SearchAddressCountry)
__attribute__((visibility ("default")))
@interface MBXSSearchAddressCountry : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithName:(nonnull NSString *)name
                         countryCode:(nullable NSString *)countryCode
                   countryCodeAlpha3:(nullable NSString *)countryCodeAlpha3;

/** Country name. */
@property (nonatomic, readonly, nonnull, copy) NSString *name;

/** iso_3166_1 alpha 2 country code. */
@property (nonatomic, readonly, nullable, copy) NSString *countryCode;

/** iso_3166_1 alpha 3 country code. */
@property (nonatomic, readonly, nullable, copy) NSString *countryCodeAlpha3;


- (BOOL)isEqualToSearchAddressCountry:(nonnull MBXSSearchAddressCountry *)other;

@end
