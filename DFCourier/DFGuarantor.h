//
//  DFGuarantor.h
//  Workbook
//
//  Created by 方秋鸣 on 2016/11/10.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DFGuarantor;

@protocol DFGuarantor

- (DFGuarantor * (^)(Protocol *))df_protocol;
- (DFGuarantor * (^)(NSArray<Protocol *> *))df_protocols;
- (DFGuarantor *)and;
- (DFGuarantor *)with;

@end

@interface DFGuarantor : NSProxy <DFGuarantor>

@property (nonatomic, readonly) NSMutableSet<Protocol *> *protocols;

- (instancetype)df_init;
- (BOOL)df_conformsToProtocol:(Protocol *)aProtocol;

@end

NS_ASSUME_NONNULL_END
