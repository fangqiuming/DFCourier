//
//  DFForwardingRule.m
//  Workbook
//
//  Created by 方秋鸣 on 2016/10/31.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

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
