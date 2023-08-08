// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSdkInformation;

/** User activity reporter options */
NS_SWIFT_NAME(UserActivityReporterOptions)
__attribute__((visibility ("default")))
@interface MBXSUserActivityReporterOptions : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithSdkInformation:(nonnull MBXSdkInformation *)sdkInformation
                                     eventsUrl:(nullable NSString *)eventsUrl;

- (nonnull instancetype)initWithSdkInformation:(nonnull MBXSdkInformation *)sdkInformation
                                     eventsUrl:(nullable NSString *)eventsUrl
                            sendEventsDebounce:(uint64_t)sendEventsDebounce
                            sendEventsInterval:(uint64_t)sendEventsInterval;

/** SDK information that forms the SDK fragment from the "User-Agent" HTTP header. */
@property (nonatomic, readonly, nonnull) MBXSdkInformation *sdkInformation;

/** Base URL for events service. Default is "https://events.mapbox.com". */
@property (nonatomic, readonly, nullable, copy) NSString *eventsUrl;

/** Interval in seconds before sending an initial activity event to the server. Default is 5 seconds. */
@property (nonatomic, readonly) uint64_t sendEventsDebounce;

/** Interval in seconds for a repeated activity event for each component. Default is 24 hours. */
@property (nonatomic, readonly) uint64_t sendEventsInterval;


- (BOOL)isEqualToUserActivityReporterOptions:(nonnull MBXSUserActivityReporterOptions *)other;

@end
