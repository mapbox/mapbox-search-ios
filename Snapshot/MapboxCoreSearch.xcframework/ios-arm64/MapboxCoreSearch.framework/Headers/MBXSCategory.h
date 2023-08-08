// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

/** SearchEngine::listCategories() result entry. */
NS_SWIFT_NAME(Category)
__attribute__((visibility ("default")))
@interface MBXSCategory : NSObject

// This class provides custom init which should be called
- (nonnull instancetype)init NS_UNAVAILABLE;

// This class provides custom init which should be called
+ (nonnull instancetype)new NS_UNAVAILABLE;

- (nonnull instancetype)initWithId:(nonnull NSString *)id_
                              icon:(nonnull NSString *)icon
                              name:(nonnull NSString *)name;

/** Category id. */
@property (nonatomic, readonly, nonnull, copy) NSString *id;

/**
 * The name of a suggested Maki icon to visualize a POI feature based on its category.
 * \sa https://labs.mapbox.com/maki-icons/.
 */
@property (nonatomic, readonly, nonnull, copy) NSString *icon;

/** Canonical category name. */
@property (nonatomic, readonly, nonnull, copy) NSString *name;


@end
