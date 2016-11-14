//
//  DFCourier+Interface.h
//  Workbook
//
//  Created by 方秋鸣 on 2016/10/31.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DFCourier;
@class DFSelectorFilter;
@class DFGuarantor;
@protocol DFSelectorFilter;
@protocol DFRestrictedSelectorFilter;

typedef NS_OPTIONS(NSUInteger, DFCourierService) {
    DFCourierServiceBasic               = 0,
    DFCourierServiceSelectorRespond     = 1 << 0,
    DFCourierServiceProtocolConformance = 1 << 1,
};

@protocol DFCourier

+ (DFCourier *)df_courier;
+ (DFCourier *)df_courierWithoutServices:(DFCourierService)services;
- (void)df_setServices:(DFCourierService)services;

- (void)df_installRules:(void (^) (DFSelectorFilter<DFSelectorFilter> *install))install;
- (void)df_updateRules:(void (^) (DFSelectorFilter<DFSelectorFilter> *update))update;
- (void)df_uninstallRules:(void (^) (DFSelectorFilter<DFRestrictedSelectorFilter> *uninstall))uninstall;
- (void)df_uninstallAllRules;

@end

@protocol DFGuarantorMaker

- (DFGuarantor * (^)(Protocol *))df_conformsToProtocol;
- (DFGuarantor * (^)(NSArray<Protocol *> *))df_conformsToProtocols;

@end

@interface DFCourier : NSProxy <DFCourier, DFGuarantorMaker>

- (DFGuarantor *)df_guarantor;

@end

NS_ASSUME_NONNULL_END
