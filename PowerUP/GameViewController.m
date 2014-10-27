//
//  GameViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "GameViewController.h"
#import "GameModel.h"
#import "Grid.h"

@interface GameViewController () <GridDelegate>
{
    int numRows;
    int numCols;
    BOOL powered;
    NSInteger level;
    
    GameModel* _model;
    Grid* _grid;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initialize model
    _model = [[GameModel alloc] init];
    
    // generate a grid
    level = 0;
    [_model generateGrid:level];
    
    CGRect frame = self.view.frame;
    
    // initilize _gridView
    float framePortion = 0.8;
    CGFloat xGrid    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    CGFloat yGrid    = CGRectGetHeight(frame) * (1 - framePortion) / 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(xGrid, yGrid, size, size);
    
    // with the generated grid we know the number of rows and cols so we can set the variables
    numRows = _model.numRows;
    numCols = _model.numCols;
    
    // initialize the grid
    _grid = [[Grid alloc] initWithFrame:gridFrame andNumRows:numRows andCols:numCols];
    _grid.delegate = self;
    
    [self.view addSubview:_grid];
    
    [self setUpDisplay];
    
    // display the back menu in appropriate language
    switch (_language) {
        case 0:
            [_back setTitle:@"Back to Menu" forState:UIControlStateNormal];
            break;
        case 1:
            [_back setTitle:@"Volver al menú" forState:UIControlStateNormal];
            break;
        case 2:
            [_back setTitle:@"回到主菜单" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void) newLevel{
    if (level <= 2)
        ++level;
    [_model generateGrid:level];
    
    [self setUpDisplay];
}

- (void) setUpDisplay{
    
    // read values from gameModel and set them to grid
    for (int row = 0; row < numRows; row++){
        for (int col = 0; col < numCols; col++){
            NSString* componentType = [_model getTypeAtRow:row andCol:col];
            [_grid setValueAtRow:row col:col to:componentType];
        }
    }
    
}

- (void) switchSelectedWithTag:(NSNumber*)tag withOrientation:(NSString*)newOrientation
{
    
    int rowSelected = [tag intValue] / 10;
    int colSelected = [tag intValue] % 10;
    [_model switchSelectedAtRow:rowSelected andCol:colSelected withOrientation:newOrientation];
}

// if the battery is on, check the circuit connection
-(void) powerOn{
    BOOL connected = [_model connected];
    if (connected) {
        [_grid win];
        
        NSString *title = @"You win!";
        
        NSString *message;
        if (level <= 1)
            message = [NSString stringWithFormat:@"Current level is unlocked. Let's try next level!"];
        else
            message = [NSString stringWithFormat:@"All levels are unlocked. Congratulation!"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (level <= 1)
        [self newLevel];
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

