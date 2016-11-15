//
// DFForwardingRule.m
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

#import "DFForwardingRule.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFForwardingRule ()

@property (nonatomic) NSString *selectorString;
@property (nonatomic, null_resettable) NSHashTable *advanceCopyTo;
@property (nonatomic, null_resettable) NSHashTable *laterCopyTo;

@end

@implementation DFForwardingRule


- (instancetype)initWithSelectorString:(NSString *)selectorString
{
    self = [super init];
    if (self) {
        self.selectorString = selectorString;
    }
    return self;
}

+ (instancetype)ruleFromSelectorString:(NSString *)selectorString
{
    return [[self alloc] initWithSelectorString:selectorString];
}

- (NSHashTable *)advanceCopyTo
{
    if (_advanceCopyTo == nil) {
        _advanceCopyTo = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _advanceCopyTo;
}

- (NSHashTable *)laterCopyTo
{
    if (_laterCopyTo == nil) {
        _laterCopyTo = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _laterCopyTo;
}

- (NSUInteger)hash
{
    return self.selectorString.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        DFForwardingRule *rule = object;
        return [self.selectorString isEqualToString:rule.selectorString];
    }
    return NO;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    DFForwardingRule *rule = [[[self class] allocWithZone:zone] initWithSelectorString:self.selectorString];
    rule.forwardTo = self.forwardTo;
    rule.advanceCopyTo = [self.advanceCopyTo copy];
    rule.laterCopyTo = [self.laterCopyTo copy];
    rule.responseFrom = self.responseFrom;
    rule.signedBy = self.signedBy;
    rule.swizzleTo = self.swizzleTo;
    return rule;
}

@end

NS_ASSUME_NONNULL_END
