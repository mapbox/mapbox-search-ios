// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSSearchAddressCountry;
@class MBXSSearchAddressRegion;

/** Address record divided in components. */
NS_SWIFT_NAME(SearchAddress)
__attribute__((visibility ("default")))
@interface MBXSSearchAddress : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithHouseNumber:(nullable NSString *)houseNumber
                                     street:(nullable NSString *)street
                               neighborhood:(nullable NSString *)neighborhood
                                   locality:(nullable NSString *)locality
                                   postcode:(nullable NSString *)postcode
                                      place:(nullable NSString *)place
                                   district:(nullable NSString *)district
                                     region:(nullable MBXSSearchAddressRegion *)region
                                    country:(nullable MBXSSearchAddressCountry *)country;

@property (nonatomic, readonly, nullable, copy) NSString *houseNumber;
@property (nonatomic, readonly, nullable, copy) NSString *street;
@property (nonatomic, readonly, nullable, copy) NSString *neighborhood;
@property (nonatomic, readonly, nullable, copy) NSString *locality;
@property (nonatomic, readonly, nullable, copy) NSString *postcode;
@property (nonatomic, readonly, nullable, copy) NSString *place;
@property (nonatomic, readonly, nullable, copy) NSString *district;
@property (nonatomic, readonly, nullable) MBXSSearchAddressRegion *region;
@property (nonatomic, readonly, nullable) MBXSSearchAddressCountry *country;

- (BOOL)isEqualToSearchAddress:(nonnull MBXSSearchAddress *)other;

@end
