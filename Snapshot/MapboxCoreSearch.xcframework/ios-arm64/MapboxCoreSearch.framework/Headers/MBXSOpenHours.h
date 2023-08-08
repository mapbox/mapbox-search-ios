// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxCoreSearch/MBXSOpenMode.h>

@class MBXSOpenPeriod;

/** Representation of Open Hours for POI. */
NS_SWIFT_NAME(OpenHours)
__attribute__((visibility ("default")))
@interface MBXSOpenHours : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithMode:(MBXSOpenMode)mode
                             periods:(nonnull NSArray<MBXSOpenPeriod *> *)periods;

/** The type of hours available. */
@property (nonatomic, readonly) MBXSOpenMode mode;

/** Array of time periods where the POI is open. Can be empty if mode != Scheduled */
@property (nonatomic, readonly, nonnull, copy) NSArray<MBXSOpenPeriod *> *periods;


@end
