//
//  GameModelTests.m
//  GameModelTests
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GameModel.h"

// Change allowed grids

@interface GameModelTests : XCTestCase  {
    GameModel* _model;
}

@end

@implementation GameModelTests

- (void)setUp {
    [super setUp];
    _model = [[GameModel alloc] init];
    [_model generateGrid:-1];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInvalidGenerateGrid
{

    // Tests for invalid input
    XCTAssertThrowsSpecific([_model generateGrid:-__INT_MAX__], NSException);
    XCTAssertThrowsSpecific([_model generateGrid:__INT_MAX__], NSException);
}


- (void) testValuesCorrectInGrid
{

    // Read in test grid
    [_model generateGrid:-1];

    // Make sure the correct components were read in by generateGrid
    // Read in switch
    XCTAssert([[_model getTypeAtRow:0 andCol:4] isEqual:@"switch"], @"Failure reading in switch");

    // Read in Bulb
    XCTAssert([[_model getTypeAtRow:0 andCol:7] isEqualToString:@"bulb"], @"Failure reading in bulb");

    // Read in wires of various configurations.
    XCTAssert([[_model getTypeAtRow:1 andCol:1] isEqualToString:@"wireXXXX"], @"Failure reading in wire with no conenctions around it");
    XCTAssert([[_model getTypeAtRow:1 andCol:3] isEqualToString:@"wireLXXX"], @"Failure reading in wire with left connection");
    XCTAssert([[_model getTypeAtRow:1 andCol:5] isEqualToString:@"wireXRXX"], @"Failure reading in wire with right conenction");
    XCTAssert([[_model getTypeAtRow:1 andCol:8] isEqualToString:@"wireXXTX"], @"Failure reading in wire with above conenction");
    XCTAssert([[_model getTypeAtRow:1 andCol:10] isEqualToString:@"wireXXXB"], @"Failure reading in wire with below conenction");
    XCTAssert([[_model getTypeAtRow:7 andCol:2] isEqualToString:@"wireLXTB"], @"Failure reading in wire with left, above, and below conenction");
    XCTAssert([[_model getTypeAtRow:7 andCol:4] isEqualToString:@"wireXRTB"], @"Failure reading in wire with right, above, and below conenction");
    XCTAssert([[_model getTypeAtRow:7 andCol:7] isEqualToString:@"wireLRXB"], @"Failure reading in wire with left, right, and below conenction");
    XCTAssert([[_model getTypeAtRow:7 andCol:10] isEqualToString:@"wireLRTB"], @"Failure reading in wire with all conenctions");
    XCTAssert([[_model getTypeAtRow:13 andCol:1] isEqualToString:@"wireXXTB"], @"Failure reading in wire with above and below switch");
    XCTAssert([[_model getTypeAtRow:13 andCol:3] isEqualToString:@"wireXRXB"], @"Failure reading in wire with right and below switch");
    XCTAssert([[_model getTypeAtRow:13 andCol:6] isEqualToString:@"wireLRTX"], @"Failure reading in wire with right, left, and above switch");
    XCTAssert([[_model getTypeAtRow:13 andCol:10] isEqualToString:@"wireLRXB"], @"Failure reading in wire with left, right, and below switch");
    XCTAssert([[_model getTypeAtRow:13 andCol:12] isEqualToString:@"wireLRTB"], @"Failure reading in wire with all switches");

    // Read in battery
    XCTAssert([[_model getTypeAtRow:3 andCol:3] isEqualToString:@"batteryNegLXTX"], @"Failure reading in negative battery with left and above connection");
    XCTAssert([[_model getTypeAtRow:3 andCol:6] isEqualToString:@"batteryNegLRXX"], @"Failure reading in negative battery with left and right connection");
    XCTAssert([[_model getTypeAtRow:3 andCol:9] isEqualToString:@"batteryNegLXXB"], @"Failure reading in negative battery with left and below connection");
    XCTAssert([[_model getTypeAtRow:5 andCol:2] isEqualToString:@"batteryPosXRTX"], @"Failure reading in positive battery with right and above connection");
    XCTAssert([[_model getTypeAtRow:5 andCol:5] isEqualToString:@"batteryPosXXTB"], @"Failure reading in positive battery with above and below connection");
    XCTAssert([[_model getTypeAtRow:5 andCol:7] isEqualToString:@"batteryPosXRXB"], @"Failure reading in positive battery with right and below connection");
    XCTAssert([[_model getTypeAtRow:5 andCol:10] isEqualToString:@"batteryPosLRTX"], @"Failure reading in positive battery with left, right, and above connection");
    XCTAssert([[_model getTypeAtRow:9 andCol:2] isEqualToString:@"batteryNegLXXB"], @"Failure reading in negative battery with left and below switch");
    XCTAssert([[_model getTypeAtRow:9 andCol:4] isEqualToString:@"batteryNegXRXX"], @"Failure reading in negative battery with right switch");
    XCTAssert([[_model getTypeAtRow:9 andCol:8] isEqualToString:@"batteryNegXXTX"], @"Failure reading in negative battery with above switch");
    XCTAssert([[_model getTypeAtRow:9 andCol:10] isEqualToString:@"batteryNegXXXB"], @"Failure reading in negative battery with below switch");
    XCTAssert([[_model getTypeAtRow:11 andCol:2] isEqualToString:@"batteryPosLXTX"], @"Failure reading in positive battery with left and above switch");
    XCTAssert([[_model getTypeAtRow:11 andCol:5] isEqualToString:@"batteryPosLRXX"], @"Failure reading in positive battery with left and right switch");
    XCTAssert([[_model getTypeAtRow:11 andCol:9] isEqualToString:@"batteryPosLXXB"], @"Failure reading in positive battery with left and below switch");
    XCTAssert([[_model getTypeAtRow:11 andCol:11] isEqualToString:@"batteryPosXRTX"], @"Failure reading in positive battery with right and above switch");

}


- (void) testGetTypeAtInvalidRowandCol
{

    // Tests for invalid input
    XCTAssertThrowsSpecific([_model getTypeAtRow:-1 andCol:0], NSException);
    XCTAssertThrowsSpecific([_model getTypeAtRow:__INT_MAX__ andCol:0], NSException);
    XCTAssertThrowsSpecific([_model getTypeAtRow:0 andCol:-1], NSException);
    XCTAssertThrowsSpecific([_model getTypeAtRow:0 andCol:__INT_MAX__], NSException);
    XCTAssertThrowsSpecific([_model getTypeAtRow:-1 andCol:-1], NSException);
    XCTAssertThrowsSpecific([_model getTypeAtRow:__INT_MAX__ andCol:__INT_MAX__], NSException);

}


- (void) testSwitchSelectedAtInvalidRowandColandOrientation
{
    // Tests for invalid row and col inputs
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:-1 andCol:0 withOrientation:@"XXXX"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:__INT_MAX__ andCol:0 withOrientation:@"XXXX"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:-1 withOrientation:@"XXXX"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:__INT_MAX__ withOrientation:@"XXXX"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:-1 andCol:-1 withOrientation:@"XXXX"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:__INT_MAX__ andCol:__INT_MAX__ withOrientation:@"XXXX"], NSException);

    // Tests for invalid orientation inputs
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:0 withOrientation:@"AAAA"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:0 withOrientation:@"XXXXX"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:0 withOrientation:@"RLBT"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:0 withOrientation:@"LXTH"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:0 withOrientation:@"XXX"], NSException);

    // Tests for locations that are not switches
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:0 andCol:0 withOrientation:@"XXXX"], NSException);
    XCTAssertThrowsSpecific([_model switchSelectedAtRow:2 andCol:7 withOrientation:@"LRTB"], NSException);
}

- (void) testGridUpdatingAtEdgeCases
{
    // Make the switch have a wire that would attempt to dash outside of grid.
    // Index out of bound error will occur if these edge cases are not accounted for
    [_model switchSelectedAtRow:0 andCol:4 withOrientation:@"XXTX"];
    [_model switchSelectedAtRow:5 andCol:0 withOrientation:@"LXXX"];
    [_model switchSelectedAtRow:14 andCol:1 withOrientation:@"XXXB"];
    [_model switchSelectedAtRow:6 andCol:14 withOrientation:@"XRXX"];
}

- (void) testGridConnection
{
    [_model generateGrid:-2]; // bring in a different grid for testing

    XCTAssertFalse([_model connected]); // originally unconnected

    [_model switchSelectedAtRow:11 andCol:8 withOrientation:@"LXXX"];
    XCTAssertFalse([_model connected]); // still unconnected

    [_model switchSelectedAtRow:11 andCol:8 withOrientation:@"LRXX"];
    [_model switchSelectedAtRow:12 andCol:2 withOrientation:@"XXTX"];
    XCTAssertFalse([_model connected]); // still unconnected

    [_model switchSelectedAtRow:12 andCol:2 withOrientation:@"XXTB"];
    XCTAssertFalse([_model connected]);

    [_model switchSelectedAtRow:12 andCol:2 withOrientation:@"XRXB"];
    XCTAssertFalse([_model connected]);

    [_model switchSelectedAtRow:12 andCol:2 withOrientation:@"XRTB"];
    XCTAssertTrue([_model connected]);

}

@end
