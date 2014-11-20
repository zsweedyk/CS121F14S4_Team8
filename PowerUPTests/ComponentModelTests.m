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

@interface ComponentModelTests : XCTestCase
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
    XCTAssertFalse([_model getState]);
}

- (void)testBasicSetandGet
{
    [_model pointTo:@"Left"];
    XCTAssert([[_model getDirection] isEqual:@"Left"], @"Get Direction failed");
    
    [_model connectedRight:YES];
    XCTAssert([_model isConnectedRight], @"isConnectedRight failed");
    [_model connectedTop:NO];
    XCTAssertFalse([_model isConnectedTop]);
    
    [_model setType:@"laser"];
    XCTAssert([[_model geType] isEqual:@"laser"], @"get Type failed");
    
    [_model setState:NO];
    XCTAssertFalse([_model getState]);
    
}

- (void)testSameComponent
{
    ComponentModel* differentType = [[ComponentModel alloc] initOfType:@"emitter" AtRow:0 AndCol:0 AndState:NO];
    ComponentModel* differentRow = [[ComponentModel alloc] initOfType:@"empty" AtRow:9 AndCol:0 AndState:NO];
    ComponentModel* differentCol = [[ComponentModel alloc] initOfType:@"empty" AtRow:0 AndCol:6 AndState:NO];
    ComponentModel* allDifferent = [[ComponentModel alloc] initOfType:@"deflector" AtRow:8 AndCol:5 AndState:NO];
    ComponentModel* same = [[ComponentModel alloc] initOfType:@"empty" AtRow:0 AndCol:0 AndState:YES];
    
    XCTAssertFalse([_model isSameComponentAs:differentType]);
    XCTAssertFalse([_model isSameComponentAs:differentRow]);
    XCTAssertFalse([_model isSameComponentAs:differentCol]);
    XCTAssertFalse([_model isSameComponentAs:allDifferent]);
    
    XCTAssert([_model isSameComponentAs:same], @"Failed comparison with same component");
}

@end
