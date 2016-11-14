//
//  DFForwardingRule.h
//  Workbook
//
//  Created by 方秋鸣 on 2016/10/31.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DFForwardingRule : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *selectorString;
@property (nonatomic, weak) id forwardTo;
@property (nonatomic, weak, nullable) id standByForwardTo;
@property (nonatomic, readonly) NSHashTable *advanceCopyTo;
@property (nonatomic, readonly) NSHashTable *laterCopyTo;
@property (nonatomic, weak, nullable) id responseFrom;
@property (nonatomic, weak, nullable) id signedBy;
@property (nonatomic, nullable) SEL swizzleTo;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSelectorString:(NSString *)selectorString NS_DESIGNATED_INITIALIZER;
+ (instancetype)ruleFromSelectorString:(NSString *)selectorString;

@end

NS_ASSUME_NONNULL_END
