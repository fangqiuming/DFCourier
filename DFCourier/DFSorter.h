//
// DFSorter.h
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

@class DFForwardingRule;

NS_ASSUME_NONNULL_BEGIN

@interface DFSorter : NSObject

@property (nonatomic) NSInteger services;
@property (nonatomic, null_resettable) NSMutableSet<Protocol *> *protocols;

+ (nullable id)winnerOf:(SEL)aSelector wei:(nullable id)wei shu:(nullable id)shu wu:(nullable id)wu;
+ (NSInvocation *)duplicateOfInvocation:(NSInvocation *)anInvocation;
- (void)addRules:(nullable NSSet *)rules;
- (void)deleteRules:(nullable NSSet *)rules;
- (void)clearRules;
- (nullable DFForwardingRule *)ruleWithSelectorString:(NSString *)selectorString;
- (void)setProtocols:(NSMutableSet<Protocol *> *)Protocols;
- (NSString *)instanceIdentifier;
- (BOOL)df_respondsToSelector:(SEL)aSelector;
- (NSMethodSignature *)df_methodSignatureForSelector:(SEL)aSelector;
- (void)df_forwardInvocation:(NSInvocation *)anInvocation;
- (BOOL)df_conformsToProtocol:(Protocol *)aProtocol;
- (BOOL)df_isEqual:(id)object;

@end

NS_ASSUME_NONNULL_END
