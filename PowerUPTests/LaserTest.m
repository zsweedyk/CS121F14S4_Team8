//
//  LaserTest.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-22.
//  Copyright (c) 2014年 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameModel.h"

@interface LaserTest : XCTestCase{
    GameModel* _model;
    LaserModel* _laserModel;
}


@end

@implementation LaserTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
     _model = [[GameModel alloc] initWithTotalLevels:6];
    _laserModel = _model.laserModel;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAdd {
    //valid component
    ComponentModel* valid = [[ComponentModel alloc]initOfType:@"emitter" AtRow:-1 AndCol:-1 AndState:NO];
    //invalid component
    ComponentModel* invalid = [[ComponentModel alloc]initOfType:@"wire" AtRow:1 AndCol:1 AndState:NO];
    
    //test for adding valid component
    [_laserModel addComponent:valid];
    int size = [_laserModel getEmitters].count;
    XCTAssert(([_laserModel getEmitters][size -1]) == valid);
    
    //test for handling invalid cases
    XCTAssertThrowsSpecific([_laserModel addComponent:invalid], NSException);
}

- (void) testEmitterReset
{
    //load the test grid, turn power on
    [_model generateGrid:-5];
    [_model powerOn];
    
    //the emitters should all be turned on since they are all connected
    for (ComponentModel* comp in [_laserModel getEmitters]){
        XCTAssertTrue([comp getState]);
    }
    
    //call laserModel to reset the components
    [_laserModel resetComponents];
    
    //the emitters should be turned off now
    for (ComponentModel* comp in [_laserModel getEmitters]){
        XCTAssert([comp getState] == NO);
    }
}

- (void) testClearComponents
{
    //generate test grid 5
    [_model generateGrid:-5];
    //turn power on, this should make the laser model to emit lasers since the emitters are already connected
    [_model powerOn];
    
    //testing if all the component arrays have something in them as they should be loaded when generating the grid
    XCTAssertFalse([_laserModel getEmitters].count == 0);
    XCTAssertFalse([_laserModel getDeflectors].count == 0);
    XCTAssertFalse([_laserModel getReceivers].count == 0);
    XCTAssertFalse([_laserModel getLasers].count == 0);
    
    //tell laserModel to clear its component arrays
    [_laserModel clearLaserComponents];
    
    //testing if all the arrays have been cleared
    XCTAssertTrue([_laserModel getEmitters].count == 0);
    XCTAssertTrue([_laserModel getDeflectors].count == 0);
    XCTAssertTrue([_laserModel getReceivers].count == 0);
    XCTAssertTrue([_laserModel getLasers].count == 0);
}

- (void)testClearLasers
{
    //load the test grid and turn power on
    [_model generateGrid:-5];
    [_model powerOn];
    
    //there should be lasers at the specified location with the specified direction
    XCTAssert([[_model getTypeAtRow:3 andCol:7] isEqual:@"laserXXTB"]);
    XCTAssert([[_model getTypeAtRow:4 andCol:7] isEqual:@"laserXXTB"]);
    XCTAssertFalse([_laserModel getLasers].count == 0);
    
    //call laserModel to clear all lasers
    [_laserModel clearLasers];
    
    //the lasers should no longer be there
    XCTAssert([[_model getTypeAtRow:3 andCol:7] isEqual:@"empty"]);
    XCTAssert([[_model getTypeAtRow:4 andCol:7] isEqual:@"empty"]);
    //there shouldn't be laser at all when power is off
    XCTAssertTrue([_laserModel getLasers].count == 0);
}

//test emitting lasers at different directions
- (void)testEmit
{
    //load test grid
    [_model generateGrid:-5];
    [_model powerOn];
    //test emit laser upwards
    XCTAssert([[_model getTypeAtRow:3 andCol:7] isEqual:@"laserXXTB"]);
    XCTAssert([[_model getTypeAtRow:4 andCol:7] isEqual:@"laserXXTB"]);
    //test emit laser downwards
    XCTAssert([[_model getTypeAtRow:10 andCol:7] isEqual:@"laserXXTB"]);
    XCTAssert([[_model getTypeAtRow:11 andCol:7] isEqual:@"laserXXTB"]);
    //test emit laser to the left
    XCTAssert([[_model getTypeAtRow:8 andCol:0] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:1] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:2] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:3] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:4] isEqual:@"laserLRXX"]);
    //test emit laser to the right
    XCTAssert([[_model getTypeAtRow:8 andCol:10] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:11] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:12] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:13] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:8 andCol:14] isEqual:@"laserLRXX"]);
}

- (void)testEmitWithInvalidInput
{
    //clear the arrays of laserModel
    //we can use it because it's been tested
    [_laserModel clearLaserComponents];
    
    //test emit with illegal row arguments
    ComponentModel* invalidRowEmitter = [[ComponentModel alloc]initOfType:@"emitter" AtRow:-1 AndCol:1 AndState:YES];
    [invalidRowEmitter pointTo:@"Right"];
    [_laserModel addComponent:invalidRowEmitter];
    XCTAssertThrowsSpecific([_laserModel updateLasers], NSException);
    
    [_laserModel clearLaserComponents];
    ComponentModel* invalidRowEmitter2 = [[ComponentModel alloc]initOfType:@"emitter" AtRow:15 AndCol:0 AndState:YES];
    [invalidRowEmitter2 pointTo:@"Bottom"];
    [_laserModel addComponent:invalidRowEmitter2];
    XCTAssertThrowsSpecific([_laserModel updateLasers], NSException);
    
    //test emit with illegal col arguments
    [_laserModel clearLaserComponents];
    ComponentModel* invalidColEmitter = [[ComponentModel alloc]initOfType:@"emitter" AtRow:1 AndCol:-1 AndState:YES];
    [invalidColEmitter pointTo:@"Right"];
    [_laserModel addComponent:invalidColEmitter];
    XCTAssertThrowsSpecific([_laserModel updateLasers], NSException);
    
    [_laserModel clearLaserComponents];
    ComponentModel* invalidColEmitter2 = [[ComponentModel alloc]initOfType:@"emitter" AtRow:1 AndCol:15 AndState:YES];
    [invalidColEmitter2 pointTo:@"Right"];
    [_laserModel addComponent:invalidColEmitter2];
    XCTAssertThrowsSpecific([_laserModel updateLasers], NSException);
    
}

- (void)testDeflectorRotate
{
    //load test grid and turn power on
    [_model generateGrid:-5];
    [_model powerOn];
    
    //there should be lasers at the specified location
    XCTAssert([[_model getTypeAtRow:2 andCol:8] isEqual:@"empty"]);
    XCTAssert([[_model getTypeAtRow:2 andCol:9] isEqual:@"empty"]);
    XCTAssert([[_model getTypeAtRow:2 andCol:10] isEqual:@"empty"]);
    XCTAssert([[_model getTypeAtRow:2 andCol:11] isEqual:@"empty"]);
    
    //rotate the deflector to point at that direction
    [_model componentSelectedAtRow:2 andCol:7 withOrientation:@"XRXB"];
    [_laserModel updateLasers];
    
    //now there should be laser beams at these locations
    XCTAssert([[_model getTypeAtRow:2 andCol:8] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:2 andCol:9] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:2 andCol:10] isEqual:@"laserLRXX"]);
    XCTAssert([[_model getTypeAtRow:2 andCol:11] isEqual:@"laserLRXX"]);
    
    //test for edge cases, now a deflector is deflecting the laser out of bound
    [_model componentSelectedAtRow:2 andCol:14 withOrientation:@"LXXB"];
    //pass if no exception is raised
    [_laserModel updateLasers];
}

- (void)testReceiver
{
    //load the test grid and turn power on
    [_model generateGrid:-5];
    [_model powerOn];
    
    //the receiver should be off
    XCTAssert([([_laserModel getReceivers][0]) getState]==NO);
    
    //rotate the deflector so that the lasers are now deflected into the receiver
    [_model componentSelectedAtRow:2 andCol:7 withOrientation:@"LXXB"];
    [_model powerOn];
    
    //test if the receiver is turned on by the laser
    XCTAssertTrue([([_laserModel getReceivers][0]) getState]);
    
    //test for reset
    [_laserModel resetComponents];
    XCTAssert([([_laserModel getReceivers][0]) getState]==NO);
}

@end
