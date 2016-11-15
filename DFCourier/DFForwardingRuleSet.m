//
// DFForwardingRuleSet.m
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

#import "DFForwardingRuleSet+Private.h"
#import "DFForwardingRule.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const df_kDefaultSelectorString = @"";

@implementation DFForwardingRuleSet

#pragma mark - Semantic properties

- (DFForwardingRuleSet *)and {
    return self;
}

- (DFForwardingRuleSet *)with {
    return self;
}

#pragma mark - Add selectors

- (NSMutableSet<__kindof DFForwardingRule *> *)rules
{
    if (_rules == nil)
    {
        _rules = [NSMutableSet set];
    }
    return _rules;
}

- (DFForwardingRuleSet *)addSelectorStrings:(NSArray <NSString *> *)selectorStrings
{
    for (NSString *string in selectorStrings) {
        DFForwardingRule *rule = [DFForwardingRule ruleFromSelectorString:string];
        if (rule) {
            [self.rules addObject:rule];
        }
    }
    return self;
}

#pragma mark - Config rules

- (DFForwardingRuleSet *)configRules:(void (^)(DFForwardingRule *rule))config
{
    [self.rules enumerateObjectsUsingBlock:^(DFForwardingRule * _Nonnull obj, BOOL * _Nonnull stop) {
        *stop = NO;
        config(obj);
    }];
    return self;
}

- (DFForwardingRuleSet * (^)(id))df_forwardTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.forwardTo = object;
        }];
    };
}

- (DFForwardingRuleSet * (^)(id))df_standByForwardTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.standByForwardTo = object;
        }];
    };
}

- (DFForwardingRuleSet * (^)(id))df_advanceCopyTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            [rule.advanceCopyTo addObject:object];;
        }];
    };
}

- (DFForwardingRuleSet * (^)(NSArray *))df_advanceCopyToList
{
    return ^DFForwardingRuleSet * (NSArray *objects) {
        return [self configRules:^(DFForwardingRule *rule) {
            for (id object in objects) {
                [rule.advanceCopyTo addObject:object];
            }
        }];
    };
}

- (DFForwardingRuleSet * (^)(id))df_laterCopyTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            [rule.laterCopyTo addObject:object];;
        }];
    };
}

- (DFForwardingRuleSet * (^)(NSArray *))df_laterCopyToList
{
    return ^DFForwardingRuleSet * (NSArray *objects) {
        return [self configRules:^(DFForwardingRule *rule) {
            for (id object in objects) {
                [rule.laterCopyTo addObject:object];
            }
        }];
    };
}

- (DFForwardingRuleSet * (^)(id))df_responseFrom
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.responseFrom = object;
        }];
    };
}

- (DFForwardingRuleSet * (^)(id))df_signedBy
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.signedBy = object;
        }];
    };
}

- (DFForwardingRuleSet * (^)(SEL))df_swizzleToSelector
{
    return ^DFForwardingRuleSet * (SEL aSelector) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.swizzleTo = aSelector;
        }];
    };
}

- (DFForwardingRuleSet * (^)(NSString *))df_swizzleToSelectorString
{
    return ^DFForwardingRuleSet * (NSString *selectorString) {
        SEL aSelector = NSSelectorFromString(selectorString);
        return [self configRules:^(DFForwardingRule *rule) {
            rule.swizzleTo = aSelector;
        }];
    };
}

#pragma mark - Debug

- (NSString *)selectorStrings
{
    NSString *selectorStrings = @"";
    for (DFForwardingRule *rule in self.rules) {
        selectorStrings = [selectorStrings stringByAppendingString:
                           [NSString stringWithFormat:@"[%@]\n", rule.selectorString]];
    }
    return selectorStrings;
}

@end

NS_ASSUME_NONNULL_END
