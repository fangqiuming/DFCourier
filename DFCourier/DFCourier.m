//
//  DFCourier.m
//  GetZ
//
//  Created by 方秋鸣 on 16/8/19.
//  Copyright © 2016年 fangqiuming.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
