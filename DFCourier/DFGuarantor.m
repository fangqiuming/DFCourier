//
//  DFGuarantor.m
//  Workbook
//
//  Created by 方秋鸣 on 2016/11/10.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import "DFGuarantor.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFGuarantor ()

@property (nonatomic, null_resettable) NSMutableSet<Protocol *> *protocols;

@end

@implementation DFGuarantor

- (instancetype)and {
    return self;
}

- (instancetype)with {
    return self;
}

- (instancetype)df_init
{
    return self;
}

- (BOOL)df_conformsToProtocol:(Protocol *)aProtocol
{
    return [self.protocols containsObject:aProtocol];
}

- (NSMutableSet<Protocol *> *)protocols
{
    if (_protocols == nil)
    {
        _protocols = [NSMutableSet set];
    }
    return _protocols;
}

- (DFGuarantor * (^)(Protocol *))df_protocol
{
    return ^DFGuarantor * (Protocol *aProtocol) {
        [self.protocols addObject:aProtocol];
        return self;
    };
}

- (DFGuarantor * (^)(NSArray<Protocol *> *))df_protocols
{
    return ^DFGuarantor * (NSArray<Protocol *> *protocols) {
        [self.protocols addObjectsFromArray:protocols];
        return self;
    };
}

@end

NS_ASSUME_NONNULL_END
