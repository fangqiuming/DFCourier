//
//  DFForwardingRuleSet+Private.h
//  Workbook
//
//  Created by 方秋鸣 on 2016/11/7.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const df_kDefaultSelectorString;

@class DFForwardingRule;

@interface DFForwardingRuleSet()

@property (nonatomic) NSMutableSet<__kindof DFForwardingRule *> *rules;

@end

NS_ASSUME_NONNULL_END
