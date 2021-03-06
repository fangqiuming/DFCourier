//
//  DFCourierExampleTests.m
//  DFCourierExampleTests
//
//  Created by 方秋鸣 on 2016/11/14.
//  Copyright © 2016年 方秋鸣. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DFCourier.h"

@interface DFCourierExampleTests : XCTestCase

@property (nonatomic) DFCourier *courier;
@property (nonatomic) id testObject;

@end

@implementation DFCourierExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testObject = [[NSObject alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.courier = nil;
    self.testObject = nil;
    [super tearDown];
}

- (void)testCourierA1Init {
    self.courier = [DFCourier df_courier];
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
