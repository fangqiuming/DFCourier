//
//  DFForwardingRuleSet.m
//  Workbook
//
//  Created by 方秋鸣 on 2016/11/1.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import "DFForwardingRule.h"
#import "DFForwardingRuleSet.h"
#import "DFForwardingRuleSet+Private.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const df_kDefaultSelectorString = @"";

@implementation DFForwardingRuleSet

#pragma mark - Semantic properties

- (instancetype)and {
    return self;
}

- (instancetype)with {
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

- (instancetype)addSelectorStrings:(NSArray <NSString *> *)selectorStrings
{
    for (NSString *string in selectorStrings) {
        DFForwardingRule *rule = [DFForwardingRule ruleFromSelectorString:string];
        if (rule) {
            [self.rules addObject:rule];
        }
    }
    return self;
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(SEL))df_selector
{
    return ^DFForwardingRuleSet * (SEL aSelector) {
        return [self addSelectorStrings:@[NSStringFromSelector(aSelector)]];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSString *))df_selectorFromString
{
    return ^DFForwardingRuleSet * (NSString *aSelectorString) {
        return [self addSelectorStrings:@[aSelectorString]];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSArray <NSString *> *))df_selectorsFromStrings
{
    return ^DFForwardingRuleSet * (NSArray <NSString *> *selectorStrings) {
        return [self addSelectorStrings:selectorStrings];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> *)df_makeDefault
{
    [self addSelectorStrings:@[df_kDefaultSelectorString]];
    return self;
}

#pragma mark - Config rules

- (instancetype)configRules:(void (^)(DFForwardingRule *rule))config
{
    [self.rules enumerateObjectsUsingBlock:^(DFForwardingRule * _Nonnull obj, BOOL * _Nonnull stop) {
        config(obj);
    }];
    return self;
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_forwardTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.forwardTo = object;
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_standByForwardTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.standByForwardTo = object;
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_advanceCopyTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            [rule.advanceCopyTo addObject:object];;
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSArray *))df_advanceCopyToList
{
    return ^DFForwardingRuleSet * (NSArray *objects) {
        return [self configRules:^(DFForwardingRule *rule) {
            for (id object in objects) {
                [rule.advanceCopyTo addObject:object];
            }
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_laterCopyTo
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            [rule.laterCopyTo addObject:object];;
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSArray *))df_laterCopyToList
{
    return ^DFForwardingRuleSet * (NSArray *objects) {
        return [self configRules:^(DFForwardingRule *rule) {
            for (id object in objects) {
                [rule.laterCopyTo addObject:object];
            }
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_responseFrom
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.responseFrom = object;
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_signedBy
{
    return ^DFForwardingRuleSet * (id object) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.signedBy = object;
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(SEL))df_swizzleToSelector
{
    return ^DFForwardingRuleSet * (SEL aSelector) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.swizzleTo = aSelector;
        }];
    };
}

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSString *))df_swizzleToSelectorString
{
    return ^DFForwardingRuleSet * (NSString *selectorString) {
        return [self configRules:^(DFForwardingRule *rule) {
            rule.swizzleTo = @selector(selectorString);
        }];
    };
}

@end

NS_ASSUME_NONNULL_END
