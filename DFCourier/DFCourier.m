//
//  DFCourier.m
//  Workbook
//
//  Created by 方秋鸣 on 2016/10/31.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import "DFCourier.h"
#import "DFCourier+Interface.h"
#import "DFSelectorFilter+Private.h"
#import "DFForwardingRuleSet+Private.h"
#import "DFForwardingRule.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFCourier ()

@property (nonatomic, setter=df_setServices:) DFCourierService df_services;
@property (nonatomic, null_resettable) NSMutableSet<DFForwardingRule *> *df_ruleBook;
@property (nonatomic, null_resettable) DFGuarantor *df_guarantor;

@end

@implementation DFCourier

#pragma mark - Creation

- (instancetype)df_init
{
    return self;
}

+ (instancetype)df_courier
{
    DFCourier *courier = [[self alloc] df_init];
    if (courier) {
        courier.df_services = DFCourierServiceBasic
        | DFCourierServiceSelectorRespond;
    }
    return courier;
}

+ (instancetype)df_courierWithoutServices:(DFCourierService)services
{
    DFCourier *courier = [self df_courier];
    if (courier) {
        courier.df_services = courier.df_services & (~services);
    }
    return courier;
}

#pragma mark - Compose methods

- (void)df_installRules:(void (^) (DFSelectorFilter<DFSelectorFilter> *install))install
{
    DFSelectorFilter<DFSelectorFilter> *filter = [[DFSelectorFilter<DFSelectorFilter> alloc] init];
    !install?: install(filter);
    [self df_addRules:filter.ruleSet.rules];
}

- (void)df_updateRules:(void (^)(DFSelectorFilter<DFSelectorFilter> * _Nonnull))update
{
    DFSelectorFilter<DFSelectorFilter> *filter = [[DFSelectorFilter<DFSelectorFilter> alloc] init];
    !update?: update(filter);
    [self df_deleteRules:filter.ruleSet.rules];
    [self df_addRules:filter.ruleSet.rules];
}

- (void)df_uninstallRules:(void (^)(DFSelectorFilter<DFRestrictedSelectorFilter> * _Nonnull))uninstall
{
    DFSelectorFilter<DFRestrictedSelectorFilter> *filter = [[DFSelectorFilter<DFRestrictedSelectorFilter> alloc] init];
    !uninstall?: uninstall(filter);
    [self df_deleteRules:filter.ruleSet.rules];
}

- (void)df_uninstallAllRules
{
    self.df_ruleBook = nil;
}

#pragma mark - Rule Book

- (NSMutableSet *)df_ruleBook
{
    if (_df_ruleBook == nil)
    {
        _df_ruleBook = [NSMutableSet set];
    }
    return _df_ruleBook;
}

- (void)df_addRules:(nullable NSSet *)rules
{
    if (rules) {
        [self.df_ruleBook unionSet:rules];
    }
}

- (void)df_deleteRules:(nullable NSSet *)rules
{
    if (rules) {
        [self.df_ruleBook minusSet:rules];
    }
}

#pragma mark - Forwarding Methods

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    DFForwardingRule *rule = [self df_ruleWithSelectorString:NSStringFromSelector(sel)];
    if (rule == nil) {
        return [super methodSignatureForSelector:sel];
    } else {
        SEL aSelector = rule.swizzleTo?: sel;
        return [[self winnerOf:aSelector
                           wei:rule.signedBy
                           shu:rule.forwardTo
                            wu:rule.standByForwardTo]
                methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    DFForwardingRule *rule = [self df_ruleWithSelectorString:NSStringFromSelector(invocation.selector)];
    if (rule == nil) {
        [super forwardInvocation:invocation];
    } else {
        if (rule.swizzleTo) {
            [invocation setSelector:rule.swizzleTo];
        }
        if (rule.advanceCopyTo.count) {
            NSInvocation *duplicate = [self duplicateOfInvocation:invocation];
            for (id object in rule.advanceCopyTo) {
                [duplicate invokeWithTarget:object];
            }
        }
        [invocation invokeWithTarget:[self winnerOf:invocation.selector
                                                wei:nil
                                                shu:rule.forwardTo
                                                 wu:rule.standByForwardTo]
         ];
        if (rule.advanceCopyTo.count) {
            NSInvocation *duplicate = [self duplicateOfInvocation:invocation];
            for (id object in rule.advanceCopyTo) {
                [duplicate invokeWithTarget:object];
            }
        }
    }
}

- (nullable DFForwardingRule *)df_ruleWithSelectorString:(NSString *)selectorString
{
    DFForwardingRule *dummyRule = [DFForwardingRule ruleFromSelectorString:selectorString];
    if([self.df_ruleBook containsObject:dummyRule]) {
        return [self.df_ruleBook member:dummyRule];
    }
    dummyRule = [DFForwardingRule ruleFromSelectorString:df_kDefaultSelectorString];
    if([self.df_ruleBook containsObject:dummyRule]) {
        return [self.df_ruleBook member:dummyRule];
    }
    return nil;
}

- (nullable id)winnerOf:(SEL)aSelector wei:(nullable id)wei shu:(nullable id)shu wu:(nullable id)wu
{
    if (wei) {
        return wei;
    }
    if (wu) {
        return [shu respondsToSelector:aSelector]? shu: wu;
    }
    return shu;
}

- (NSInvocation *)duplicateOfInvocation:(NSInvocation *)anInvocation
{
    NSMethodSignature *signature = anInvocation.methodSignature;
    NSInvocation *duplicate = [NSInvocation invocationWithMethodSignature:signature];
    //copy selector.
    [duplicate setSelector:anInvocation.selector];
    //copy args.
    for (NSUInteger i = 2; i < signature.numberOfArguments; i ++) {
        const char *type = [signature getArgumentTypeAtIndex:i];
        NSUInteger argSize;
        void *argBuf = NULL;
        NSGetSizeAndAlignment(type, &argSize, NULL);
        if (!(argBuf = reallocf(argBuf,argSize))) {
            break;
        }
        [anInvocation getArgument:argBuf atIndex:i];
        [duplicate setArgument:argBuf atIndex:i];
    }
    return duplicate;
}

#pragma mark - Config Services

- (void)df_setServices:(DFCourierService)services
{
    if (services & DFCourierServiceSelectorRespond) {
        [self df_installRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull install) {
            install.df_filterSelector(@selector(respondsToSelector:)).df_forwardTo(self).df_swizzleToSelector(@selector(df_respondsToSelector:));
        }];
    }
    if (services & DFCourierServiceProtocolConformance) {
        [self df_installRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull install) {
            install.df_filterSelector(@selector(conformsToProtocol:)).df_forwardTo(self.df_guarantor).df_swizzleToSelector(@selector(df_conformsToProtocol:));
        }];
    }
}

#pragma mark - Selector Respond

- (BOOL)df_respondsToSelector:(SEL)aSelector
{
    DFForwardingRule *rule = [self df_ruleWithSelectorString:NSStringFromSelector(aSelector)];
    if (rule == nil) {
        return [self respondsToSelector:aSelector];
    } else {
        SEL sel = rule.swizzleTo?: aSelector;
        return [[self winnerOf:aSelector
                           wei:rule.signedBy
                           shu:rule.forwardTo
                            wu:rule.standByForwardTo]
                respondsToSelector:sel];
    }
}

#pragma mark - Protocol Conformance

- (DFGuarantor *)df_guarantor
{
    if (_df_guarantor == nil)
    {
        _df_guarantor = [[DFGuarantor alloc] df_init];
    }
    return _df_guarantor;
}

- (DFGuarantor * (^)(Protocol *))df_conformsToProtocol
{
    return ^DFGuarantor * (Protocol *aProtocol) {
        [self.df_guarantor.protocols removeAllObjects];
        [self.df_guarantor.protocols addObject:aProtocol];
        return self.df_guarantor;
    };
}

- (DFGuarantor * (^)(NSArray<Protocol *> *))df_conformsToProtocols
{
    return ^DFGuarantor * (NSArray<Protocol *> *protocols) {
        [self.df_guarantor.protocols removeAllObjects];
        [self.df_guarantor.protocols addObjectsFromArray:protocols];
        return self.df_guarantor;
    };
}

@end

NS_ASSUME_NONNULL_END
