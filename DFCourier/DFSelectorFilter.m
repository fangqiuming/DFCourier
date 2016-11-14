//
//  DFSelectorFilter.m
//  Workbook
//
//  Created by 方秋鸣 on 2016/10/28.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import "DFSelectorFilter.h"
#import "DFSelectorFilter+Private.h"
#import "DFForwardingRuleSet.h"
#import "DFForwardingRuleSet+Private.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DFSelectorFilter

- (DFForwardingRuleSet * (^)(SEL))filterSelector
{
    return ^DFForwardingRuleSet * (SEL aSelector) {
         return self.ruleSet.df_selector(aSelector);
    };
}
- (DFForwardingRuleSet * (^)(NSString *))filterSelectorFromString
{
    return ^DFForwardingRuleSet * (NSString *selectorString) {
        return self.ruleSet.df_selectorFromString(selectorString);
    };
}
- (DFForwardingRuleSet * (^)(NSArray<NSString *> *))filterSelectorsFromStrings
{
    return ^DFForwardingRuleSet * (NSArray<NSString *> *selectorStrings) {
        return self.ruleSet.df_selectorsFromStrings(selectorStrings);
    };
}

- (DFForwardingRuleSet *)df_default
{
    return self.ruleSet.df_selectorFromString(df_kDefaultSelectorString);
}

- (DFForwardingRuleSet<DFForwardingRuleSet> *)ruleSet
{
    if (_ruleSet == nil)
    {
        _ruleSet = [[DFForwardingRuleSet<DFForwardingRuleSet> alloc] init];
    }
    return _ruleSet;
}

@end

NS_ASSUME_NONNULL_END
