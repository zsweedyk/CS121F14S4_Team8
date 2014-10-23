//
//  Grid.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Grid.h"
#import "Wire.h"
#import "Bulb.h"

@interface Grid() 
{
    int _numRows;
    int _numCols;
    int _bulbRow;
    int _bulbCol;
    NSMutableArray* _cells;
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

- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    _cells = [[NSMutableArray alloc] init];
    
    [self setUpGridForNumRows:rows andCols:cols];
    
    return self;
}

- (void) setUpGridForNumRows:(int)rows andCols:(int)cols
{
    _numRows = rows;
    _numCols = cols;
    
    // calculate dimension of the cell that makes it fit in the frame
    CGFloat cellHeight = self.frame.size.height/_numRows;
    CGFloat cellWidth = self.frame.size.width/_numCols;
    CGFloat cellSize = MIN(cellHeight, cellWidth);
    
    // Set each cell on the grid
    for (int row = 0; row < _numRows; ++row){
        NSMutableArray* rowCells = [[NSMutableArray alloc] init];
        for (int col = 0; col < _numCols; ++col){
            // location of cell
            CGFloat xLabel = col * cellSize;
            CGFloat yLabel = row * cellSize;
            
            // initially set all cells to a white label. Initialized to proper component later
            CGRect labelFrame = CGRectMake(xLabel, yLabel, cellSize, cellSize);
            UILabel* blankTile = [[UILabel alloc] initWithFrame:labelFrame];
            blankTile.tag = row*10+col; // keep track of where each cell is
            [blankTile setBackgroundColor:[UIColor whiteColor]];
            
            [self addSubview:blankTile];
            [rowCells addObject:blankTile];
        }
        
        [_cells addObject:rowCells];
    }
    
    
}

// 0 empty cell
// 1 wire
// 2 battery neg
// 6,3 battery pos
// 4 bulb
// 5 bulb connector
// 9 switch
- (void)setValueAtRow:(int)row col:(int)col to:(NSString*)componentType{
    
    // white label to replace
    UILabel* label = [[_cells objectAtIndex:row] objectAtIndex:col];
    [label removeFromSuperview];
    
    // new component to replace with
    UIView* newComponent;
    
    // check component type and use the appropriate object
    NSString* typeIndicator = [componentType substringWithRange:NSMakeRange(0, 2)];
    if ([typeIndicator isEqual: @"wi"]) { // wire case
        newComponent = [[Wire alloc] initWithFrame:label.frame andOrientation:componentType];
    } else if ([typeIndicator isEqual:@"ba"]) { // battery case
        newComponent = [[UIImageView alloc] initWithFrame:label.frame];
        [(UIImageView*)newComponent setImage:[UIImage imageNamed:componentType]];
    } else if ([typeIndicator isEqual:@"bu"]) { // bulb case
        _bulbRow = row;
        _bulbCol = col;
        newComponent = [[Bulb alloc] initWithFrame:label.frame];
    } else if ([typeIndicator isEqual:@"sw"]) { // switch case
        newComponent = [[Switch alloc] initWithFrame:label.frame];
        ((Switch*)newComponent).delegate = self;
    } else {
        newComponent = label;
    }
    newComponent.tag = label.tag;
    [self addSubview:newComponent];
    [[_cells objectAtIndex:row] setObject:newComponent atIndex:col];
    
}

- (void) switchSelected:(id)sender
{
    NSNumber* senderTag = [[NSNumber alloc] initWithInt:(int)((Switch*)sender).tag];
    
    NSString* newOrientation = [(Switch*)sender rotateSwitch];

    [self.delegate performSelector:@selector(switchSelectedWithTag:withOrientation:) withObject:senderTag withObject:newOrientation];
}


- (void) win{
    
    [(Bulb*)[[_cells objectAtIndex:_bulbRow] objectAtIndex:_bulbCol] lightUp];
    
    NSString *title = @"You win!";
    
    NSString *message = [NSString stringWithFormat:@"You are awesome!"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];

}

@end
