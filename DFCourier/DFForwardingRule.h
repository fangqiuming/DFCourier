//
// DFForwardingRule.h
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
