//
// DFCourier+Interface.h
// Copyright (c) 2016 FANG QIUMING
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@class DFCourier, DFForwardingRuleSet, DFSelectorFilter, DFProtocolFilter;
@protocol DFSelectorFilter, DFRestrictedSelectorFilter, DFProtocolFilter;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, DFCourierService) {
    DFCourierServiceBasic               = 0,
    DFCourierServiceSelectorRespond     = 1 << 0,
    DFCourierServiceProtocolConformance = 1 << 1,
};

@protocol DFCourier
@optional
+ (DFCourier *)df_courier;
+ (DFCourier *)df_courierWithoutServices:(DFCourierService)services;
- (void)df_setServices:(DFCourierService)services;

- (void)df_makeDefaultRule:(void (^)(DFForwardingRuleSet *set))make;
- (void)df_removeDefaultRule;
- (void)df_installRules:(void (^)(DFSelectorFilter<DFSelectorFilter> *filter))install;
- (void)df_updateRules:(void (^)(DFSelectorFilter<DFSelectorFilter> *filter))update;
- (void)df_uninstallRules:(void (^)(DFSelectorFilter<DFRestrictedSelectorFilter> *filter))uninstall;
- (void)df_uninstallAllRules;
@end

@protocol DFGuarantor
@optional
- (void)df_conformToProtocol:(nullable void (^)(DFProtocolFilter<DFProtocolFilter> *conform))conform;
@end

@interface DFCourier : NSProxy <DFCourier, DFGuarantor>
@end

NS_ASSUME_NONNULL_END
