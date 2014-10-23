//
//  Grid.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Grid.h"

@interface Grid()
{
    int numRows;
    int numCols;
    BOOL topSwitch;
    BOOL botSwitch;
    NSMutableArray* _grids;
}
@end

@implementation Grid

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame size:(CGFloat) frameSize
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    CGFloat gridNum = 15;
    CGFloat gridSize = frameSize / gridNum;
    
    _grids = [[NSMutableArray alloc] init];
    for (int row = 0; row < gridNum; row++){
        // create an array of nine buttons that makes up a row
        NSMutableArray* rowArray = [[NSMutableArray alloc] init];
        for (int col = 0; col < gridNum; col++){
            CGFloat x = col * gridSize;
            CGFloat y = row * gridSize;
            
            // create button and assign property for the button
            CGRect buttonFrame = CGRectMake(x, y, gridSize, gridSize);
            UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
            button.tag = row * 10 + col; // e.g: for the cell of row 2 col 7, the tag is 27
            [button setBackgroundColor:[UIColor whiteColor]];
            //[button setBackgroundImage:[UIImage imageNamed:@"gray-highlight.png"] forState:UIControlStateHighlighted];
            //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [self addSubview:button];
            [rowArray addObject:button];
            
            //[button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_grids addObject:rowArray];
    }
    
    return self;
}

- (void)setValueAtRow:(int) row col:(int)col to:(NSString*)value{
    UIButton* button = _grids[row][col];
    
    // 0 empty cell
    // 1 wire
    // 2 battery neg
    // 6,3 battery pos
    // 4 bulb
    // 5 bulb connector
    // 9 switch
    
    if ([value  isEqual: @"0"]){
        [button setEnabled:NO];
    } else if ([value  isEqual: @"1"]){
        [button setEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"bulb_short.png"] forState:UIControlStateNormal];
    } else if ([value  isEqual: @"2"]){
        [button setEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"bulb_short.png"] forState:UIControlStateNormal];
    } else if ([value  isEqual: @"3"] || [value  isEqual: @"6"]){
        [button setEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"batteryNegLRXX.png"] forState:UIControlStateNormal];
    } else if ([value  isEqual: @"4"]){
        [button setEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"bulb_normal.png"] forState:UIControlStateNormal];
    } else if ([value  isEqual: @"5"]){
        [button setEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"bulb_normal.png"] forState:UIControlStateNormal];
    } else if ([value  isEqual: @"9"]){
        [button setBackgroundImage:[UIImage imageNamed:@"bulb_short.png"] forState:UIControlStateNormal];
    }
    
}

- (void) setGame{
    
}

- (void) switchSelected{
    
}

- (void) win{
    
}

- (void) setElectricity{
    
}

@end
