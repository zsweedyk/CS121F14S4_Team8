//
//  GameViewController.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "GameViewController.h"
#import "GameModel.h"
#import "Grid.h"

@interface GameViewController ()
{
    int numRows;
    int numCols;
    BOOL powered;
    
    GameModel* _model;
    Grid* _grid;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Currently a 15x15 grid
    numRows = 15;
    numCols = 15;
    CGRect frame = self.view.frame;
    
    //Initialize model
    _model = [[GameModel alloc] init];
    
    // initilize _gridView
    float framePortion = 0.8;
    CGFloat xGrid    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    CGFloat yGrid    = CGRectGetHeight(frame) * (1 - framePortion) / 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(xGrid, yGrid, size, size);
    
    _grid = [[Grid alloc] initWithFrame:gridFrame size:size];
    [self.view addSubview:_grid];
    [_grid setTarget:self action:@selector(switchSelectedAtRow:col:)];
    
    [self startNewGame];
}

- (void) restart{
    // read values from gameModel and set them to grid
    for (int row = 0; row < numRows; row++){
        for (int col = 0; col < numCols; col++){
            NSString* value = [_model getTypeAtRow:row andCol:col];
            NSString* imageName = [self imageName:value AtRow:row col:col];
            [_grid setValueAtRow:row col:col to:imageName];
        }
    }
    
}

// determine the name of the image based on the type and the connection
- (NSString*) imageName:(NSString*) type AtRow:(int) r col:(int) c{
    if ([type  isEqual: @"1"] || [type isEqual:@"5"]) {
        type = @"wire";
        type = [type stringByAppendingString:[_model getConnectionsAtRow:r andCol:c]];
    }else if ([type  isEqual: @"2"]) {
        type = @"batteryPos";
        type = [type stringByAppendingString:[_model getConnectionsAtRow:r andCol:c]];
    }else if ([type  isEqual: @"3"] || [type  isEqual: @"6"]) {
        type = @"batteryNeg";
        type = [type stringByAppendingString:[_model getConnectionsAtRow:r andCol:c]];
    }else if ([type  isEqual: @"4"]) {
        //no short case for now
        //if (shorted)
        //    type = @"bulb_short";
        //if (powered)
        //    type = @"bulb_light";
        //else
            type = @"bulb_short";
    } else if ([type isEqual:@"0"] || [type isEqual:@"9"]) {
        type = @"blank";
    }
    return type;
}

- (void) startNewGame{
    [_model generateGrid];
    [self restart];
}

- (void) switchSelectedAtRow:(NSNumber*)row col:(NSNumber*)col
{
    // convert row and col to int
    int selectedRow = [row intValue];
    int selectedCol = [col intValue];
    
    // debug use
    //NSLog(@"%d",selectedRow);
    //NSLog(@"%d",selectedCol);
    
    // flip the value of the switch
    NSString* value = [_model getTypeAtRow:selectedRow  andCol:selectedCol];
    if ([value isEqual:@"9"])
    {
        [_model setValueAtRow:selectedRow andCol:selectedCol withValue:@"1"];
        [_grid setValueAtRow:selectedRow col:selectedCol to:[self imageName:@"1" AtRow:selectedRow col:selectedCol]];
    } else if ([value isEqual:@"1"])
    {
        [_model setValueAtRow:selectedRow andCol:selectedCol withValue:@"9"];
        [_grid setValueAtRow:selectedRow col:selectedCol to:[self imageName:@"9" AtRow:selectedRow col:selectedCol]];
    }
    
    // check connections
    powered = [_model connected];
    
    if (powered)
    {
        [_grid setElectricityAtRow:5 col:7];
        [_grid win];
        //[self startNewGame];
    } else {
        [_grid setNoElectricityAtRow:5 col:7];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
