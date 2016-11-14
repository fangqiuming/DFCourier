//
//  DFSelectorFilter.h
//  Workbook
//
//  Created by 方秋鸣 on 2016/10/28.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DFForwardingRuleSet;
@protocol DFSelectorPicker;
@protocol DFForwardingRuleSet;

@protocol DFRestrictedSelectorFilter

- (DFForwardingRuleSet<DFSelectorPicker> * (^)(SEL))df_filterSelector;
- (DFForwardingRuleSet<DFSelectorPicker> * (^)(NSString *))df_filterSelectorFromString;
- (DFForwardingRuleSet<DFSelectorPicker> * (^)(NSArray<NSString *> *))df_filterSelectorsFromStrings;
- (DFForwardingRuleSet<DFSelectorPicker> * (^)(SEL))df_default;

@end

@protocol DFSelectorFilter <DFRestrictedSelectorFilter>

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(SEL))df_filterSelector;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSString *))df_filterSelectorFromString;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSArray<NSString *> *))df_filterSelectorsFromStrings;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(SEL))df_default;

@end

@interface DFSelectorFilter : NSObject

@end

NS_ASSUME_NONNULL_END
