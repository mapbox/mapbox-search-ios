// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * "search.feedback" event properties.
 * \sa https://github.com/mapbox/event-schema/blob/master/lib/base-schemas/search.feedback.js
 */
NS_SWIFT_NAME(FeedbackProperties)
__attribute__((visibility ("default")))
@interface MBXSFeedbackProperties : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithFeedbackReason:(nonnull NSString *)feedbackReason
                                  feedbackText:(nullable NSString *)feedbackText
                                    screenshot:(nullable NSData *)screenshot
                                reportLocation:(nullable CLLocation *)reportLocation
                                     appUserId:(nullable NSString *)appUserId
                                  appSessionId:(nullable NSString *)appSessionId
                                    feedbackId:(nullable NSString *)feedbackId
                                        isTest:(BOOL)isTest;

/** Feedback reason. Mandatory field. */
@property (nonatomic, readonly, nonnull, copy) NSString *feedbackReason;

/** Feedback optional text. */
@property (nonatomic, readonly, nullable, copy) NSString *feedbackText;

/** Raw bitmap image bytes (500px JPEG). */
@property (nonatomic, readonly, nullable) NSData *screenshot;

/** User's location for feedback event. Resolved via LocationProvider by default. */
@property (nonatomic, readonly, nullable) CLLocation *reportLocation;

/** Unique user ID. */
@property (nonatomic, readonly, nullable, copy) NSString *appUserId;

/** Application session ID. */
@property (nonatomic, readonly, nullable, copy) NSString *appSessionId;

/** Optional UUID that will be used as the feedback ID, if provided. */
@property (nonatomic, readonly, nullable, copy) NSString *feedbackId;

/** Flag indicating that this event is sent with test purpose. */
@property (nonatomic, readonly) BOOL isTest;


@end
