#import "WeakRef.h"

@implementation WeakRef

- (instancetype)initWithReference:(id)reference {
    self = [super init];
    self.reference = reference;
    return self;
}

@end
