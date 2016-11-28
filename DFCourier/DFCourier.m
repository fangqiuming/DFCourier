//
// DFCourier.m
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

#import "DFCourier+Private.h"
#import "DFSelectorFilter+Private.h"
#import "DFProtocolFilter+Private.h"
#import "DFForwardingRuleSet+Private.h"
#import "DFForwardingRule.h"
#import "DFSorter.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DFCourier

#pragma mark - Creation

- (instancetype)df_init
{
    [self df_setServices:DFCourierServiceSelectorRespond
    | DFCourierServiceProtocolConformance];
    return self;
}

+ (instancetype)df_courier
{
    return [[self alloc] df_init];
}

+ (instancetype)df_courierWithoutServices:(DFCourierService)services
{
    DFCourier *courier = [self df_courier];
    if (courier) {
        [courier df_setServices:courier.df_sorter.services & (~services)];
    }
    return courier;
}

- (DFSorter *)df_sorter
{
    if (_df_sorter == nil)
    {
        _df_sorter = [[DFSorter alloc] init];
    }
    return _df_sorter;
}

- (NSString *)df_instanceIdentifier
{
    return self.df_sorter.instanceIdentifier;
}

#pragma mark - Composition Methods

- (void)df_makeDefaultRule:(void (^)(DFForwardingRuleSet * _Nonnull))make
{
    DFForwardingRuleSet *defaultSet = [DFSelectorFilter<DFSelectorFilter> alloc].init.df_selectorFromString(df_kDefaultSelectorString).ruleSet;
    !make?: make(defaultSet);
    [self.df_sorter deleteRules:defaultSet.rules];
    [self.df_sorter addRules:defaultSet.rules];
}

- (void)df_removeDefaultRule
{
    DFForwardingRuleSet *defaultSet = [DFSelectorFilter<DFSelectorFilter> alloc].init.df_selectorFromString(df_kDefaultSelectorString).ruleSet;
    [self.df_sorter deleteRules:defaultSet.rules];
}

- (void)df_installRules:(void (^)(DFSelectorFilter<DFSelectorFilter> * _Nonnull))install
{
    DFSelectorFilter<DFSelectorFilter> *filter = [[DFSelectorFilter<DFSelectorFilter> alloc] init];
    !install?: install(filter);
    for (DFForwardingRuleSet *ruleSet in filter.ruleSets) {
        [self.df_sorter addRules:ruleSet.rules];
    }
}

- (void)df_updateRules:(void (^)(DFSelectorFilter<DFSelectorFilter> * _Nonnull))update
{
    DFSelectorFilter<DFSelectorFilter> *filter = [[DFSelectorFilter<DFSelectorFilter> alloc] init];
    !update?: update(filter);
    for (DFForwardingRuleSet *ruleSet in filter.ruleSets) {
        [self.df_sorter deleteRules:ruleSet.rules];
    }
    for (DFForwardingRuleSet *ruleSet in filter.ruleSets) {
        [self.df_sorter addRules:ruleSet.rules];
    }
}

- (void)df_uninstallRules:(void (^)(DFSelectorFilter<DFRestrictedSelectorFilter> * _Nonnull))uninstall
{
    DFSelectorFilter<DFRestrictedSelectorFilter> *filter = [[DFSelectorFilter<DFRestrictedSelectorFilter> alloc] init];
    !uninstall?: uninstall(filter);
    for (DFForwardingRuleSet *ruleSet in filter.ruleSets) {
        [self.df_sorter deleteRules:ruleSet.rules];
    }
}

- (void)df_uninstallAllRules
{
    [self.df_sorter clearRules];
}

- (void)df_conformToProtocol:(nullable void (^)(DFProtocolFilter<DFProtocolFilter> * _Nonnull))conform
{
    DFProtocolFilter<DFProtocolFilter> *filter = [[DFProtocolFilter alloc] init];
    !conform?: conform(filter);
    [self.df_sorter setProtocols:filter.protocols];
}

#pragma mark - Forwarding Methods

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self.df_sorter df_methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [self.df_sorter df_forwardInvocation:anInvocation];
}

#pragma mark - Config Services

- (void)df_setServices:(DFCourierService)services
{
    [self df_uninstallRules:^(DFSelectorFilter<DFRestrictedSelectorFilter> * _Nonnull filter) {
        filter.df_selector(@selector(respondsToSelector:)).and.df_selector(@selector(respondsToSelector:));
    }];
    if (services & DFCourierServiceSelectorRespond) {
        [self df_updateRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull filter) {
            filter.df_selector(@selector(respondsToSelector:)).df_forwardTo(self.df_sorter).df_swizzleToSelector(@selector(df_respondsToSelector:));
        }];
    }
    if (services & DFCourierServiceProtocolConformance) {
        [self df_updateRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull filter) {
            filter.df_selector(@selector(conformsToProtocol:)).df_forwardTo(self.df_sorter).df_swizzleToSelector(@selector(df_conformsToProtocol:));
        }];
    }
}

@end

NS_ASSUME_NONNULL_END
