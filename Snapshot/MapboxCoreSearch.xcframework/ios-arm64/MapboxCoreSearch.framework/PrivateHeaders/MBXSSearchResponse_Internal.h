// This file is generated and will be overwritten automatically.

#import <MapboxCoreSearch/MBXSSearchResponse.h>

@interface MBXSSearchResponse ()
- (nonnull instancetype)initWithRequest:(nonnull MBXSRequestOptions *)request
                                results:(nonnull MBXExpected<NSArray<MBXSSearchResult *> *, MBXSError *> *)results
                           responseUUID:(nonnull NSString *)responseUUID;
@property (nonatomic, readonly, nonnull) MBXExpected<NSArray<MBXSSearchResult *> *, MBXSError *> *results;
@end
