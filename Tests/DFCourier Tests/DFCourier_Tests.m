//
// DFCourier_Tests.m
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

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "DFPrivate.h"

@protocol DFCourierTestObject
@required
- (void)testMethod1:(NSInteger)number;
- (NSDate *)testMethod6;
@optional
- (instancetype)testMethod3;
@end
@interface DFCourierTestObject : NSObject
- (id)testMethod0;
- (void)testMethod2:(NSInteger)number;
- (instancetype)testMethod4;
- (id)testMethod5;
@end
@interface DFCourierTestObject () <DFCourierTestObject>
@property (nonatomic) NSUInteger testMethod0InvokeCount;
@property (nonatomic) NSInteger testMethod1LastParameter;
@property (nonatomic) NSInteger testMethod2SummationOfParameters;
@property (nonatomic) NSDate *testMethod6InvokeTime;
@end
@implementation DFCourierTestObject
- (id)testMethod0 {return [NSNumber numberWithUnsignedInteger:++ _testMethod0InvokeCount];}
- (void)testMethod1:(NSInteger)number {_testMethod1LastParameter = number;}
- (void)testMethod2:(NSInteger)number {_testMethod2SummationOfParameters += number;}
- (instancetype)testMethod3 {return self;}
- (instancetype)testMethod4 {return [self testMethod3];}
- (id)testMethod5 {return nil;}
- (NSDate *)testMethod6 {return ({_testMethod6InvokeTime = [NSDate date]; _testMethod6InvokeTime;});}
@end

@interface DFCourier_Tests : XCTestCase
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation DFCourier_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test0 {
    id courier = [DFCourier df_courier];
    
    DFCourierTestObject *testObjNil = nil;
    DFCourierTestObject *testObjForwardTo = [[DFCourierTestObject alloc] init];
    DFCourierTestObject *testObjAdvanceCopyTo = [[DFCourierTestObject alloc] init];
    DFCourierTestObject *testObjLaterCopyTo = [[DFCourierTestObject alloc] init];
    DFCourierTestObject *testObjNewForwardTo = [[DFCourierTestObject alloc] init];
    
    [courier df_installRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull filter) {
        filter.df_selector(@selector(testMethod0)).df_forwardTo(testObjForwardTo);
        filter.df_selectorsInProtocol(@protocol(DFCourierTestObject)).df_forwardTo(testObjForwardTo).df_advanceCopyTo(testObjAdvanceCopyTo).df_laterCopyTo(testObjLaterCopyTo);
        XCTAssertEqual([filter.ruleSets count], (unsigned long)3);
        DFForwardingRule *rule = [[[filter.ruleSets firstObject].rules allObjects] firstObject];
        XCTAssertNotEqualObjects(rule, filter);
        XCTAssertEqualObjects(rule.forwardTo, [[rule copy] forwardTo]);
    }];
    
    [courier testMethod0];
    [courier testMethod0];
    XCTAssertEqual([testObjForwardTo testMethod0InvokeCount], (unsigned long)2);
    
    if ([courier respondsToSelector:@selector(testMethod1:)]) {
        [courier testMethod1:23];
    }
    XCTAssertEqual([testObjForwardTo testMethod1LastParameter], 23);
    
    if ([courier respondsToSelector:@selector(testMethod2:)]) {
        [courier testMethod2:24];
        [courier testMethod2:1];
    }
    XCTAssertEqual([testObjForwardTo testMethod2SummationOfParameters], 0);

    NSDate *dateReturn = [courier testMethod6];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDate *dateAdvanceCopyTo = testObjAdvanceCopyTo.testMethod6InvokeTime;
        NSDate *dateForwardTo = testObjForwardTo.testMethod6InvokeTime;
        NSDate *dateLaterCopyTo = testObjLaterCopyTo.testMethod6InvokeTime;
        XCTAssertNotNil(dateAdvanceCopyTo);
        XCTAssertNotNil(dateLaterCopyTo);
        XCTAssertEqualObjects(dateReturn, dateForwardTo);
        NSAssert([dateAdvanceCopyTo timeIntervalSinceDate:dateForwardTo] < 0, nil);
        NSAssert([dateLaterCopyTo timeIntervalSinceDate:dateForwardTo] > 0, nil);
    });
    
    [courier df_installRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull filter) {
        filter.df_selector(@selector(testMethod2:)).and.df_selectorsFromStrings(@[@"testMethod3",@"testMethod4"]).with.df_forwardTo(testObjNil).with.df_standByForwardTo(testObjNewForwardTo).df_responseFrom(testObjNil).df_signedBy(testObjForwardTo);
        filter.df_selector(@selector(testMethod5)).df_forwardTo(testObjNewForwardTo).and.df_swizzleToSelectorString(@"testMethod0").and.df_advanceCopyToList(@[testObjAdvanceCopyTo]).with.df_laterCopyToList(@[testObjAdvanceCopyTo]);
    }];
    
    NSAssert([courier respondsToSelector:@selector(testMethod3)], nil);
    NSAssert([courier methodSignatureForSelector:@selector(testMethod4)], nil);
    NSAssert([[courier testMethod4] isEqual:testObjNewForwardTo], nil);
    
    id object = [courier testMethod5];
    NSAssert([object unsignedIntegerValue] == 1, nil);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertEqual([testObjAdvanceCopyTo testMethod0InvokeCount], (unsigned long)2);
    });
    
    [courier df_uninstallAllRules];
    XCTAssertThrows([courier testMethod5]);
}

- (void)testDefaultRule {
    DFCourier *courier = [DFCourier df_courierWithoutServices:DFCourierServiceSelectorRespond];
    [courier df_makeDefaultRule:^(DFForwardingRuleSet * _Nonnull set) {
        set.df_forwardTo(self);
    }];
    NSAssert([courier isKindOfClass:[XCTestCase class]], nil);
}

- (void)testResponse0 {
    DFCourier *courier = [DFCourier df_courier];
    [courier df_makeDefaultRule:^(DFForwardingRuleSet * _Nonnull set) {
        set.df_responseFrom(courier).df_forwardTo(self);
    }];
    NSAssert([courier respondsToSelector:@selector(df_forwardInvocation:)], nil);
    NSAssert(![courier respondsToSelector:@selector(tearDown:)], nil);
    [courier df_removeDefaultRule];
    NSAssert(![courier respondsToSelector:@selector(tearDown:)], nil);
}

- (void)testRuntime0 {
    id courier = [DFCourier df_courier];
    DFCourierTestObject *testObj = [[DFCourierTestObject alloc] init];
    [courier df_installRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull filter) {
        filter.df_selectorsInClassOrSuperOf([DFCourierTestObject class]).df_forwardTo(testObj);
    }];
    NSAssert([courier respondsToSelector:@selector(testMethod0)], nil);
    NSAssert([courier respondsToSelector:@selector(isEqual:)], nil);
    
    [courier df_uninstallRules:^(DFSelectorFilter<DFRestrictedSelectorFilter> * _Nonnull filter) {
        filter.df_selectorsInClass([DFCourierTestObject class]);
    }];
    NSAssert(![courier respondsToSelector:@selector(testMethod0)], nil);
    NSAssert([courier respondsToSelector:@selector(isEqual:)], nil);
}

- (void)testRuntime1 {
    id courier = [DFCourier df_courier];
    DFCourierTestObject *testObj = [[DFCourierTestObject alloc] init];
    [courier df_installRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull filter) {
        filter.df_selectorsInProtocol(@protocol(DFCourierTestObject)).df_forwardTo(testObj);
    }];
    [courier testMethod1:2];
    id object = [testObj testMethod3];
    XCTAssertEqual(testObj.testMethod1LastParameter, 2);
    NSAssert([testObj isEqual:object], nil);
    NSAssert(![courier respondsToSelector:@selector(testMethod0)], nil);
    NSAssert([courier respondsToSelector:@selector(testMethod1:)], nil);
}

- (void)testProtocolConformance0 {
    DFCourier *courier = [DFCourier df_courier];
    [courier df_conformToProtocol:^(DFProtocolFilter<DFProtocolFilter> * _Nonnull conform) {
        conform.df_protocol(@protocol(UITableViewDelegate));
    }];
    NSAssert([courier conformsToProtocol:@protocol(UITableViewDelegate)], nil);
    NSAssert(![courier conformsToProtocol:@protocol(UITableViewDataSource)], nil);
    
    [courier df_conformToProtocol:nil];
    NSAssert(![courier conformsToProtocol:@protocol(UITableViewDelegate)], nil);
    NSAssert(![courier conformsToProtocol:@protocol(NSObject)], nil);
}

- (void)testProtocolConformance1 {
    DFCourier *courier = [DFCourier df_courier];
    [courier df_conformToProtocol:^(DFProtocolFilter<DFProtocolFilter> * _Nonnull conform) {
        conform.df_protocols(@[@protocol(UITableViewDataSource), @protocol(UIWebViewDelegate)]).and.df_protocol(@protocol(UITableViewDelegate)).with.df_protocols(@[@protocol(UITableViewDataSource)]);
    }];
    NSAssert([courier conformsToProtocol:@protocol(UITableViewDelegate)], nil);
    NSAssert([courier conformsToProtocol:@protocol(UIWebViewDelegate)], nil);

    [courier df_updateRules:^(DFSelectorFilter<DFSelectorFilter> * _Nonnull filter) {
        filter.df_selector(@selector(conformsToProtocol:)).df_forwardTo(self);
    }];
    NSAssert([courier conformsToProtocol:@protocol(NSObject)], nil);
    NSAssert(![courier conformsToProtocol:@protocol(UITableViewDataSource)], nil);
}

@end

#pragma clang diagnostic pop
