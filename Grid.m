//
//  Grid.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Grid.h"
#import "Wire.h"
#import "Bulb.h"
#import "Battery.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface Grid()
{
    int _numRows;
    int _numCols;
    NSMutableArray* _bulbRows;
    NSMutableArray* _bulbCols;
    NSMutableArray* _batRows;
    NSMutableArray* _batCols;
    NSMutableArray* _cells;
    
    AVAudioPlayer* _audioPlayerPressed;
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
    
    [self setUpGridForNumRows:rows andCols:cols];
    
    _batCols = [[NSMutableArray alloc] init];
    _batRows = [[NSMutableArray alloc] init];
    _bulbCols = [[NSMutableArray alloc] init];
    _bulbRows = [[NSMutableArray alloc] init];
    
    // sound set up
    NSString *pressedPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *pressedPathURL = [NSURL fileURLWithPath : pressedPath];
    _audioPlayerPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:pressedPathURL error:nil];
    
    return self;
}

- (void) setUpGridForNumRows:(int)rows andCols:(int)cols
{
    _cells = [[NSMutableArray alloc] init];
    
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
    
    // new component to replace with
    UIView* newComponent;
    
    // check component type and use the appropriate object
    NSString* typeIndicator = [componentType substringWithRange:NSMakeRange(0, 2)];
    if ([typeIndicator isEqual: @"wi"]) { // wire case
        newComponent = [[Wire alloc] initWithFrame:label.frame andOrientation:componentType];
        //((Wire*)newComponent).delegate = self;
    } else if ([typeIndicator isEqual:@"ba"]) { // battery case
        [_batRows addObject:[NSNumber numberWithInt:row]];
        [_batCols addObject:[NSNumber numberWithInt:col]];
        newComponent = [[Battery alloc] initWithFrame:label.frame andOrientation:componentType];
        ((Battery*)newComponent).delegate = self;
    } else if ([typeIndicator isEqual:@"bu"]) { // bulb case
        [_bulbRows addObject:[NSNumber numberWithInt:row]];
        [_bulbCols addObject:[NSNumber numberWithInt:col]];
        newComponent = [[Bulb alloc] initWithFrame:label.frame];
        //((Bulb*)newComponent).delegate = self;
    } else if ([typeIndicator isEqual:@"sw"]) { // switch case
        newComponent = [[Switch alloc] initWithFrame:label.frame];
        ((Switch*)newComponent).delegate = self;
    } else {
        newComponent = label;
        [newComponent setBackgroundColor:[UIColor whiteColor]];
    }
    newComponent.tag = label.tag;
    [self addSubview:newComponent];
    [[_cells objectAtIndex:row] setObject:newComponent atIndex:col];
    
}

- (void) switchSelected:(id)sender
{
    NSNumber* senderTag = [[NSNumber alloc] initWithInt:(int)((Switch*)sender).tag];
    
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
    
    NSString* newOrientation = [(Switch*)sender rotateSwitch];
    
    [self.delegate performSelector:@selector(switchSelectedWithTag:withOrientation:) withObject:senderTag withObject:newOrientation];
}

- (void) wireSelected:(id)sender
{
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
}

- (void) powerUp:(id)sender
{
    //[(Battery*)sender turnedOn];
    
    [self.delegate performSelector:@selector(powerOn)];
}


- (void) win{
    
    for (int i = 0; i < _bulbCols.count; i++)
    {
        int bulbRow = [_bulbRows[i] integerValue];
        int bulbCol = [_bulbCols[i] integerValue];
        [(Bulb*)[[_cells objectAtIndex:bulbRow] objectAtIndex:bulbCol] lightUp];
    }
    
}

- (void) shorted{
    for (int i = 0; i < _batCols.count; i++)
    {
        int batRow = [_batRows[i] integerValue];
        int batCol = [_batCols[i] integerValue];
        [(Battery*)[[_cells objectAtIndex:batRow] objectAtIndex:batCol] exploded];
    }}

@end
