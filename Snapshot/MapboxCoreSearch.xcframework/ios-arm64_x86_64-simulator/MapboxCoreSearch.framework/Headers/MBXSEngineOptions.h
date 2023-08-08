// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCoreSearch/MBXSApiType.h>

@class MBXSdkInformation;

/** SearchEngine options. */
NS_SWIFT_NAME(EngineOptions)
__attribute__((visibility ("default")))
@interface MBXSEngineOptions : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithBaseUrl:(nullable NSString *)baseUrl
                                apiType:(nullable NSNumber *)apiType
                         sdkInformation:(nullable MBXSdkInformation *)sdkInformation
                              eventsUrl:(nullable NSString *)eventsUrl;

/** Base URL for server API. Default is "https://api.mapbox.com". */
@property (nonatomic, readonly, nullable, copy) NSString *baseUrl;

/** Server API type. Default is ApiType::Geocoding. */
@property (nonatomic, readonly, nullable) NSNumber *apiType;

/**
 * An optional SDK information that forms the SDK fragment from the "User-Agent" HTTP header. Enables telemetry events if set.
 * Available in the 'sdkInformation' property in the event template created by SearchEngine::createEventTemplate().
 */
@property (nonatomic, readonly, nullable) MBXSdkInformation *sdkInformation;

/** Base URL for events service. Default is "https://events.mapbox.com". */
@property (nonatomic, readonly, nullable, copy) NSString *eventsUrl;


@end
