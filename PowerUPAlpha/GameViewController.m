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
    BOOL topSwitch;
    BOOL botSwitch;
    
    GameModel* _model;
    Grid* _grid;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    [self startNewGame];
}

- (void) restart{
    
    for (int row = 0; row < numRows; row++){
        for (int col = 0; col < numCols; col++){
            NSString* value = [_model getTypeAtRow:row andCol:col];
            [_grid setValueAtRow:row col:col to:value];
        }
    }
    
}

- (void) startNewGame{
    [_model generateGrid];
    [self restart];
}

- (void) switchSelected{
    
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
