// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBXSUserActivityReporterOptions;

/** Interface for reporting user activities. */
NS_SWIFT_NAME(UserActivityReporter)
__attribute__((visibility ("default")))
@interface MBXSUserActivityReporter : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

/**
 * Create the reporter with the given options.
 *
 * @param options UserActivityReporterOptions structure.
 *
 * @return UserActivityReporter instance.
 */
+ (nonnull MBXSUserActivityReporter *)getOrCreateForOptions:(nonnull MBXSUserActivityReporterOptions *)options __attribute((ns_returns_retained));
/**
 * Report user activity for specific component.
 *
 * @param component Component name (e.g. "autofill", "autocomplete", etc).
 */
- (void)reportActivityForComponent:(nonnull NSString *)component;

@end
