//
//  ComponentModelTests.m
//  PowerUP
//
//  Created by Sean on 11/20/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ComponentModel.h"

@interface ComponentModelTests : XCTestCase ()
{
    ComponentModel* _model;
}

@end

@implementation ComponentModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _model = [[ComponentModel alloc] initOfType:@"empty" AtRow:0 AndCol:0 AndState:NO];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialization
{
    XCTAssert([[_model getType] isEqual:@"empty"], @"Initialization of type failed");
    XCTAssert([_model getRow] == 0, @"Initialization of row failed");
    XCTAssert([_model getCol] == 0, @"Initialization of col failed");
    XCTAssertFalse([_model getState], @"Initialization of state failed");
}

- (void)testComparison
{
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
