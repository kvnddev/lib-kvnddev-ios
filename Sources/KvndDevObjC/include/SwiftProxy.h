#import <UIKit/UIKit.h>
#import "WeakRef.h"

NS_ASSUME_NONNULL_BEGIN

@interface SwiftProxy: NSProxy

- (instancetype)init;

@property (strong, nonnull) NSArray <Protocol *>* protocolsToConformTo;

@property (strong, nonnull) NSArray <WeakRef *>* proxies;

@end

NS_ASSUME_NONNULL_END
