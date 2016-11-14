//
//  DFSelectorFilter+Private.h
//  Workbook
//
//  Created by 方秋鸣 on 2016/11/7.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DFForwardingRuleSet;
@protocol DFForwardingRuleSet;

@interface DFSelectorFilter ()

@property (nonatomic, null_resettable) DFForwardingRuleSet<DFForwardingRuleSet> *ruleSet;

@end

NS_ASSUME_NONNULL_END
