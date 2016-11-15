//
// DFSelectorFilter.h
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

NS_ASSUME_NONNULL_BEGIN

@interface DFSelectorFilter : NSObject
@end

@protocol DFRestrictedSelectorFilter
- (DFSelectorFilter<DFRestrictedSelectorFilter> *)and;
- (DFSelectorFilter<DFRestrictedSelectorFilter> *)with;
- (DFSelectorFilter<DFRestrictedSelectorFilter> * (^)(SEL))df_selector;
- (DFSelectorFilter<DFRestrictedSelectorFilter> * (^)(NSString *))df_selectorFromString;
- (DFSelectorFilter<DFRestrictedSelectorFilter> * (^)(NSArray<NSString *> *))df_selectorsFromStrings;
- (DFSelectorFilter<DFRestrictedSelectorFilter> * (^)(Class))df_selectorsInClass;
- (DFSelectorFilter<DFRestrictedSelectorFilter> * (^)(Class))df_selectorsInClassOrSuperOf;
- (DFSelectorFilter<DFRestrictedSelectorFilter> * (^)(Protocol *))df_selectorsInProtocol;
@end

@class DFForwardingRuleSet;
@protocol DFSelectorFilter <DFRestrictedSelectorFilter>
- (DFSelectorFilter<DFSelectorFilter> *)and;
- (DFSelectorFilter<DFSelectorFilter> *)with;
- (DFSelectorFilter<DFSelectorFilter> * (^)(SEL))df_selector;
- (DFSelectorFilter<DFSelectorFilter> * (^)(NSString *))df_selectorFromString;
- (DFSelectorFilter<DFSelectorFilter> * (^)(NSArray<NSString *> *))df_selectorsFromStrings;
- (DFSelectorFilter<DFSelectorFilter> * (^)(Class))df_selectorsInClass;
- (DFSelectorFilter<DFSelectorFilter> * (^)(Class))df_selectorsInClassOrSuperOf;
- (DFSelectorFilter<DFSelectorFilter> * (^)(Protocol *))df_selectorsInProtocol;
- (DFForwardingRuleSet * (^)(id))df_forwardTo;
@end

NS_ASSUME_NONNULL_END
