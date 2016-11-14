//
//  DFForwardingRuleSet.h
//  Workbook
//
//  Created by 方秋鸣 on 2016/11/1.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DFForwardingRuleSet;

@protocol DFSelectorPicker

- (DFForwardingRuleSet<DFSelectorPicker> * (^)(SEL))df_selector;
- (DFForwardingRuleSet<DFSelectorPicker> * (^)(NSString *))df_selectorFromString;
- (DFForwardingRuleSet<DFSelectorPicker> * (^)(NSArray<NSString *> *))df_selectorsFromStrings;
- (DFForwardingRuleSet<DFSelectorPicker> *)and;
- (DFForwardingRuleSet<DFSelectorPicker> *)with;

@end

@protocol DFForwardingRuleSet <DFSelectorPicker>

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(SEL))df_selector;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSString *))df_selectorFromString;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSArray<NSString *> *))df_selectorsFromStrings;

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_forwardTo;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_standByForwardTo;

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_advanceCopyTo;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSArray *))df_advanceCopyToList;

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_laterCopyTo;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSArray *))df_laterCopyToList;

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_responseFrom;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(id))df_signedBy;

- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(SEL))df_swizzleToSelector;
- (DFForwardingRuleSet<DFForwardingRuleSet> * (^)(NSString *))df_swizzleToSelectorString;

- (DFForwardingRuleSet<DFForwardingRuleSet> *)df_makeDefault;

- (DFForwardingRuleSet<DFForwardingRuleSet> *)and;
- (DFForwardingRuleSet<DFForwardingRuleSet> *)with;

@end

@interface DFForwardingRuleSet : NSObject <DFForwardingRuleSet>
@end

NS_ASSUME_NONNULL_END
