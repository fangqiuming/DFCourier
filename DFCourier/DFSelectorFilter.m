//
// DFSelectorFilter.m
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

#import "DFSelectorFilter+Private.h"
#import "DFForwardingRuleSet+Private.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface DFSelectorFilter () <DFSelectorFilter>

@end

@implementation DFSelectorFilter


- (DFSelectorFilter<DFSelectorFilter> *)and {
    return self;
}

- (DFSelectorFilter<DFSelectorFilter> *)with {
    return self;
}

- (DFSelectorFilter<DFSelectorFilter> * (^)(SEL))df_selector
{
    return ^DFSelectorFilter<DFSelectorFilter> * (SEL aSelector) {
        [self.ruleSet addSelectorStrings:@[NSStringFromSelector(aSelector)]];
        return self;
    };
}

- (DFSelectorFilter<DFSelectorFilter> * (^)(NSString *))df_selectorFromString
{
    return ^DFSelectorFilter<DFSelectorFilter> * (NSString *aSelectorString) {
        [self.ruleSet addSelectorStrings:@[aSelectorString]];
        return self;
    };
}

- (DFSelectorFilter<DFSelectorFilter> * (^)(NSArray <NSString *> *))df_selectorsFromStrings
{
    return ^DFSelectorFilter<DFSelectorFilter> * (NSArray <NSString *> *selectorStrings) {
        [self.ruleSet addSelectorStrings:selectorStrings];
        return self;
    };
}

- (DFSelectorFilter<DFSelectorFilter> * (^)(Class))df_selectorsInClass
{
    return ^DFSelectorFilter<DFSelectorFilter> * (Class aClass) {
        [self.ruleSet addSelectorStrings:[self instanceMethodNamesOfClass:aClass inherited:NO]];
        return self;
    };
}

- (DFSelectorFilter<DFSelectorFilter> * (^)(Class))df_selectorsInClassOrSuperOf
{
    return ^DFSelectorFilter<DFSelectorFilter> * (Class aClass) {
        [self.ruleSet addSelectorStrings:[self instanceMethodNamesOfClass:aClass inherited:YES]];
        return self;
    };
}

- (DFSelectorFilter<DFSelectorFilter> * (^)(Protocol *))df_selectorsInProtocol
{
    return ^DFSelectorFilter<DFSelectorFilter> * (Protocol *aProtocol) {
        [self.ruleSet addSelectorStrings:[self methodNamesInProtocol:aProtocol]];
        return self;
    };
}

- (DFForwardingRuleSet * (^)(id))df_forwardTo
{
    DFForwardingRuleSet *ruleSet = [self ruleSet];
    [self.ruleSets addObject:[[DFForwardingRuleSet alloc] init]];
    return ruleSet.df_forwardTo;
}

-(NSArray<NSString *> *)instanceMethodNamesOfClass:(Class)aClass inherited:(BOOL)inherited
{
    NSMutableArray<NSString *> *methods = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(aClass, &methodCount);
    for(NSUInteger i = 0; i < methodCount; i ++)
    {
        Method method = methodList[i];
        SEL aSelector = method_getName(method);
        [methods addObject:NSStringFromSelector(aSelector)];
    }
    free(methodList);
    if (inherited && [aClass superclass]) {
        [methods addObjectsFromArray:[self instanceMethodNamesOfClass:[aClass superclass] inherited:YES]];
    }
    return methods;
}

-(NSArray<NSString *> *)methodNamesInProtocol:(Protocol *)aProtocol
{
    NSMutableArray<NSString *> *methods = [NSMutableArray array];
    for (NSUInteger i = 0; i < 2; i ++) {
        unsigned int methodCount = 0;
        struct objc_method_description *methodList = protocol_copyMethodDescriptionList(aProtocol, i, YES, &methodCount);
        for(NSUInteger j = 0; j < methodCount; j ++)
        {
            struct objc_method_description *method = &methodList[j];
            NSString *name = NSStringFromSelector(method->name);
            if (name.length) {
                [methods addObject:NSStringFromSelector(method->name)];
            }
        }
    }
    return methods;
}

- (NSMutableArray<DFForwardingRuleSet *> *)ruleSets
{
    if (_ruleSets == nil)
    {
        _ruleSets = [NSMutableArray array];
    }
    return _ruleSets;
}

- (DFForwardingRuleSet *)ruleSet
{
    DFForwardingRuleSet *ruleSet = [self.ruleSets lastObject];
    if (ruleSet == nil) {
        ruleSet = [[DFForwardingRuleSet alloc] init];
        [self.ruleSets addObject:ruleSet];
    }
    return ruleSet;
}

@end

NS_ASSUME_NONNULL_END
