//
//  DFCourier.m
//  GetZ
//
//  Created by 方秋鸣 on 16/8/19.
//  Copyright © 2016年 fangqiuming.com. All rights reserved.
//

#import "DFCourier.h"

@interface DFCourier ()

@end

@implementation DFCourier

#pragma mark - Message Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    DFCourierProxyOption proxyOption = DFCourierProxyOptionNone;
    if ([self.proxy conformsToProtocol:@protocol(DFCourierProxy)]) {
        proxyOption = [self.proxy proxyOptionForSelector:aSelector];
    }
    if ((proxyOption & DFCourierProxyOptionInstead) || (proxyOption & DFCourierProxyOptionAlways)) {
        return [self.proxy respondsToSelector:aSelector];
    }
    if ([self.target respondsToSelector:aSelector]) {
        return YES;
    }
    if (proxyOption & DFCourierProxyOptionReserve) {
        return [self.proxy respondsToSelector:aSelector];
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (signature == nil) {
        DFCourierProxyOption proxyOption = DFCourierProxyOptionNone;
        if ([self.proxy conformsToProtocol:@protocol(DFCourierProxy)]) {
            proxyOption = [self.proxy proxyOptionForSelector:aSelector];
        }
        if ((proxyOption & DFCourierProxyOptionInstead) || (proxyOption & DFCourierProxyOptionAlways)) {
            signature = [self.proxy methodSignatureForSelector:aSelector];
        } else {
            signature = [self.target methodSignatureForSelector:aSelector];
            if (signature == nil && (proxyOption & DFCourierProxyOptionReserve)) {
                signature = [self.proxy methodSignatureForSelector:aSelector];
            }
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    DFCourierProxyOption proxyOption = 0;
    NSInvocation *proxyInvocation;
    BOOL isInvoked = NO;
    if ([self.proxy conformsToProtocol:@protocol(DFCourierProxy)]) {
        proxyOption = [self.proxy proxyOptionForSelector:anInvocation.selector];
    }
    if ((proxyOption & DFCourierProxyOptionBefore) || (proxyOption & DFCourierProxyOptionAfter)) {
        //build a invocation.
        NSMethodSignature *signature = anInvocation.methodSignature;
        proxyInvocation = [NSInvocation invocationWithMethodSignature:signature];
        //copy selector.
        [proxyInvocation setSelector:anInvocation.selector];
        //copy args.
        for (NSUInteger i = 2; i < signature.numberOfArguments; i ++) {
            const char *type = [signature getArgumentTypeAtIndex:i];
            NSUInteger argSize;
            void *argBuf = NULL;
            NSGetSizeAndAlignment(type, &argSize, NULL);
            if (!(argBuf = reallocf(argBuf,argSize))) {
                break;
            }
            [anInvocation getArgument:argBuf atIndex:i];
            [proxyInvocation setArgument:argBuf atIndex:i];
        }
        //return value won't be used.
    }
    // Before
    if (proxyOption & DFCourierProxyOptionBefore) {
        [proxyInvocation invokeWithTarget:self.proxy];
    }
    // Invoking
    if (proxyOption & DFCourierProxyOptionInstead) {
        [anInvocation invokeWithTarget:self.proxy];
        isInvoked = YES;
    }
    if (!(proxyOption & DFCourierProxyOptionAlways) && isInvoked == NO) {
        if ([self.target respondsToSelector:anInvocation.selector] || !(proxyOption & DFCourierProxyOptionReserve)) {
            [anInvocation invokeWithTarget:self.target];
            isInvoked = YES;
        }
    }
    if ((proxyOption & DFCourierProxyOptionReserve) && isInvoked == NO) {
        [anInvocation invokeWithTarget:self.proxy];
    }
    // After
    if (proxyOption & DFCourierProxyOptionAfter) {
        [proxyInvocation invokeWithTarget:self.proxy];
    }
}

#pragma mark - Inheritance & Protocol Conformance

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    if ([super conformsToProtocol:aProtocol]) {
        return YES;
    }
    if ([self.target conformsToProtocol:aProtocol] && self.isProtocolForwarding) {
        return YES;
    }
    return NO;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    if ([super isKindOfClass:aClass]) {
        return YES;
    }
    if ([self.target isKindOfClass:aClass] && self.isInheritanceForwarding) {
        return YES;
    }
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    if ([super isMemberOfClass:aClass]) {
        return YES;
    }
    if ([self.target isMemberOfClass:aClass] && self.isClassForwarding) {
        return YES;
    }
    return NO;
}

@end
