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
    id _target;
    SEL _action;
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
            
            [self addSubview:button];
            [rowArray addObject:button];
            
            [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_grids addObject:rowArray];
    }
    
    return self;
}

- (void)cellSelected:(id)sender
{
    UIButton* button = (UIButton*) sender;
    int buttonTag = (int) button.tag;
    int row = buttonTag / 10;
    int col = buttonTag % 10;
    // debug use
    NSLog(@"%d",row);
    NSLog(@"%d",col);
    
    // the switch is selected
    if (row == 9 && col == 9)
    {
        [self switchSelectedAtRow:row col:col];
    }
}

// 0 empty cell
// 1 wire
// 2 battery neg
// 6,3 battery pos
// 4 bulb
// 5 bulb connector
// 9 switch
- (void)setValueAtRow:(int) row col:(int)col to:(NSString*)value{
    UIButton* button = _grids[row][col];
    [button setBackgroundImage:[UIImage imageNamed:value] forState:UIControlStateNormal];
}

- (void) setGame{
    
}

- (void) switchSelectedAtRow:(int) row col:(int)col{
    [_target performSelector:_action withObject:[NSNumber numberWithInt:row] withObject:[NSNumber numberWithInt:col]];
}

- (void) win{
    NSString *title = @"You win!";
    
    NSString *message = [NSString stringWithFormat:@"You are awesome!"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];

}

- (void) setElectricityAtRow:(int) row col:(int) col{
    [self setValueAtRow:row col:col to:@"bulb_light"];
}

- (void) setNoElectricityAtRow:(int) row col:(int) col{
    [self setValueAtRow:row col:col to:@"bulb_short"];
}

- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

@end
