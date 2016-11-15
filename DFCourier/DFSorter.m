//
// DFSorter.m
// Copyright (c) 2016 FANG QIUMING
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DFSorter.h"
#import "DFCourier+Private.h"
#import "DFForwardingRuleSet+Private.h"
#import "DFForwardingRule.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFSorter ()

@property (nonatomic, null_resettable) NSMutableSet<__kindof DFForwardingRule *> *ruleBook;
@property (nonatomic, readonly) NSString *instanceIdentifier;

@end

@implementation DFSorter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _instanceIdentifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}

+ (nullable id)winnerOf:(SEL)aSelector wei:(nullable id)wei shu:(nullable id)shu wu:(nullable id)wu
{
    if (wei) {
        return wei;
    }
    if (wu) {
        return [shu respondsToSelector:aSelector]? shu: wu;
    }
    return shu;
}

+ (NSInvocation *)duplicateOfInvocation:(NSInvocation *)anInvocation
{
    NSMethodSignature *signature = anInvocation.methodSignature;
    NSInvocation *duplicate = [NSInvocation invocationWithMethodSignature:signature];
    [duplicate setSelector:anInvocation.selector];
    for (NSUInteger i = 2; i < signature.numberOfArguments; i ++) {
        const char *type = [signature getArgumentTypeAtIndex:i];
        NSUInteger argSize;
        void *argBuf = NULL;
        NSGetSizeAndAlignment(type, &argSize, NULL);
        if (!(argBuf = reallocf(argBuf,argSize))) {
            break;
        }
        [anInvocation getArgument:argBuf atIndex:i];
        [duplicate setArgument:argBuf atIndex:i];
    }
    return duplicate;
}

- (void)addRules:(nullable NSSet *)rules
{
    if (rules) {
        [self.ruleBook unionSet:rules];
    }
}

- (void)deleteRules:(nullable NSSet *)rules
{
    if (rules) {
        [self.ruleBook minusSet:rules];
    }
}

- (void)clearRules
{
    self.ruleBook = nil;
}

- (BOOL)df_respondsToSelector:(SEL)aSelector
{
    DFForwardingRule *rule = [self ruleWithSelectorString:NSStringFromSelector(aSelector)];
    if (rule == nil) {
        return [self respondsToSelector:aSelector];
    } else {
        SEL sel = rule.swizzleTo?: aSelector;
        id responser = [DFSorter winnerOf:sel
                                   wei:rule.responseFrom
                                   shu:rule.forwardTo
                                    wu:rule.standByForwardTo];
        return [self df_isEqual:responser]? [self respondsToSelector:aSelector]: [responser respondsToSelector:sel];;
    }
}

- (NSMethodSignature *)df_methodSignatureForSelector:(SEL)aSelector
{
    DFForwardingRule *rule = [self ruleWithSelectorString:NSStringFromSelector(aSelector)];
    if (rule == nil) {
        return [self methodSignatureForSelector:aSelector];
    } else {
        SEL sel = rule.swizzleTo?: aSelector;
        id signer = [DFSorter winnerOf:sel
                                   wei:rule.signedBy
                                   shu:rule.forwardTo
                                    wu:rule.standByForwardTo];
        return [self df_isEqual:signer]? [self methodSignatureForSelector:sel]: [signer methodSignatureForSelector:sel];;
    }
}
- (void)df_forwardInvocation:(NSInvocation *)anInvocation
{
    DFForwardingRule *rule = [self ruleWithSelectorString:NSStringFromSelector(anInvocation.selector)];
    if (rule == nil) {
        [super forwardInvocation:anInvocation];
    } else {
        if (rule.swizzleTo) {
            [anInvocation setSelector:rule.swizzleTo];
        }
        if (rule.advanceCopyTo.count) {
            NSInvocation *duplicate = [[self class] duplicateOfInvocation:anInvocation];
            for (id object in rule.advanceCopyTo) {
                [duplicate invokeWithTarget:object];
            }
        }
        [anInvocation invokeWithTarget:[[self class] winnerOf:anInvocation.selector
                                                    wei:nil
                                                    shu:rule.forwardTo
                                                     wu:rule.standByForwardTo]
         ];
        if (rule.advanceCopyTo.count) {
            NSInvocation *duplicate = [[self class] duplicateOfInvocation:anInvocation];
            for (id object in rule.advanceCopyTo) {
                [duplicate invokeWithTarget:object];
            }
        }
    }
}

- (BOOL)df_conformsToProtocol:(Protocol *)aProtocol
{
    return [self.protocols containsObject:aProtocol];
}

- (BOOL)df_isEqual:(id)object
{
    if ([NSStringFromClass([DFCourier class]) isEqualToString:NSStringFromClass([object class])]) {
        DFCourier *aCourier = object;
        return [[self instanceIdentifier] isEqualToString:[aCourier df_instanceIdentifier]];
    }
    return NO;
}

- (nullable DFForwardingRule *)ruleWithSelectorString:(NSString *)selectorString
{
    DFForwardingRule *dummyRule = [DFForwardingRule ruleFromSelectorString:selectorString];
    if([self.ruleBook containsObject:dummyRule]) {
        return [self.ruleBook member:dummyRule];
    }
    dummyRule = [DFForwardingRule ruleFromSelectorString:df_kDefaultSelectorString];
    if([self.ruleBook containsObject:dummyRule]) {
        return [self.ruleBook member:dummyRule];
    }
    return nil;
}

- (NSMutableSet<__kindof DFForwardingRule *> *)ruleBook
{
    if (_ruleBook == nil)
    {
        _ruleBook = [NSMutableSet set];
    }
    return _ruleBook;
}

- (NSMutableSet<Protocol *> *)protocols
{
    if (_protocols == nil)
    {
        _protocols = [NSMutableSet set];
    }
    return _protocols;
}

@end

NS_ASSUME_NONNULL_END
