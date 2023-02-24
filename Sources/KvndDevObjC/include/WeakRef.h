#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakRef<__covariant ObjectType> : NSObject

- (instancetype)initWithReference:(nullable ObjectType)reference;

@property (nonatomic, weak, nullable) ObjectType reference;

@end

NS_ASSUME_NONNULL_END
