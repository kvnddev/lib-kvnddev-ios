#import "SwiftProxy.h"

@interface NSMethodSignature (ReturnType)

@property (readonly, getter=isMethodReturnTypeVoid) BOOL isMethodReturnTypeVoid;

@end

@implementation NSMethodSignature (ReturnType)

- (BOOL)isMethodReturnTypeVoid {
    return [self methodReturnLength] == 0;
}

@end


@interface NSArray (Suffix)

- (instancetype)suffixFromIndex:(NSInteger)index;

@end

@implementation NSArray (Suffix)

- (instancetype)suffixFromIndex:(NSInteger)index {
    if (self.count == 0) {
        return self;
    }
    NSMutableArray *arrayCopy = self.mutableCopy;
    [arrayCopy removeObjectAtIndex:0];
    return arrayCopy;
}

@end


@implementation SwiftProxy

- (instancetype)init {
    return self;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if ([self.protocolsToConformTo containsObject:aProtocol]) {
        return YES;
    }
    return [super conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    WeakRef *main = self.proxies.firstObject;
    NSArray <WeakRef *> *others = [self.proxies suffixFromIndex:1];

    for (WeakRef *proxy in others) {
        if ([proxy.reference respondsToSelector:aSelector]) {
            NSMethodSignature *signature = [proxy.reference methodSignatureForSelector:aSelector];
            if (signature.isMethodReturnTypeVoid) {
                return YES;
            }
        }
    }
    return [main.reference respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    WeakRef *main = self.proxies.firstObject;
    NSArray <WeakRef *> *others = [self.proxies suffixFromIndex:1];

    if (invocation.methodSignature.isMethodReturnTypeVoid) {
        for (WeakRef *proxy in others) {
            if ([proxy.reference respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:proxy.reference];
            }
        }
    }

    if ([main.reference respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:main.reference];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    WeakRef *main = self.proxies.firstObject;

    NSMethodSignature *signature = [main.reference methodSignatureForSelector:sel];
    if (signature == nil) {
        NSArray <WeakRef *> *others = [self.proxies suffixFromIndex:1];
        for (WeakRef *proxy in others) {
            signature = [proxy.reference methodSignatureForSelector:sel];
            if (signature != nil) {
                break;
            }
        }
    }
    return signature;
}

@end
