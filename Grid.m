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

    _numRows = rows;
    _numCols = cols;

    //initialize _cells 2-D array
    _cells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _numRows; ++i) {
        NSMutableArray* rowCells = [[NSMutableArray alloc] init];
        [_cells addObject:rowCells];
    }

    [self setUpGrid];
    
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

- (void) setUpGrid
{
    // reset bat and bulb coordinates
    _batCols = [[NSMutableArray alloc] init];
    _batRows = [[NSMutableArray alloc] init];
    _bulbCols = [[NSMutableArray alloc] init];
    _bulbRows = [[NSMutableArray alloc] init];
    
    // calculate dimension of the cell that makes it fit in the frame
    CGFloat cellHeight = self.frame.size.height/_numRows;
    CGFloat cellWidth = self.frame.size.width/_numCols;
    CGFloat cellSize = MIN(cellHeight, cellWidth);
    
    // Set each cell on the grid
    for (int row = 0; row < _numRows; ++row){
        for (int col = 0; col < _numCols; ++col){
            // location of cell
            CGFloat xLabel = col * cellSize;
            CGFloat yLabel = row * cellSize;
            
            // initially set all cells to a clear label. Initialized to proper component later
            CGRect labelFrame = CGRectMake(xLabel, yLabel, cellSize, cellSize);
            UILabel* blankTile = [[UILabel alloc] initWithFrame:labelFrame];
            [blankTile setBackgroundColor:[UIColor whiteColor]];
            
            [self addSubview:blankTile];
            [_cells[row] addObject:blankTile];
        }
        

    }
}

// components table:
// 0: blank
// 1: wire
// 3: negative battery
// 6: positive battery
// 4: bulb
// 7: switch
- (void)setValueAtRow:(int)row col:(int)col to:(NSString*)componentType
{
    // white label to replace
    UIView* label = [[_cells objectAtIndex:row] objectAtIndex:col];

    // new component to replace with
    UIView* newComponent;
    
    // check component type and use the appropriate object
    NSString* typeIndicator = [componentType substringWithRange:NSMakeRange(0, 2)];
    
    if ([typeIndicator isEqual: @"wi"]) {
        // wire case
        newComponent = [[Wire alloc] initWithFrame:label.frame andOrientation:componentType];
    } else if ([typeIndicator isEqual:@"ba"]) {
        // battery case
        [_batRows addObject:[NSNumber numberWithInt:row]];
        [_batCols addObject:[NSNumber numberWithInt:col]];
        newComponent = [[Battery alloc] initWithFrame:label.frame andOrientation:componentType];
        ((Battery*)newComponent).delegate = self;
    } else if ([typeIndicator isEqual:@"bu"]) {
        // bulb case
        [_bulbRows addObject:[NSNumber numberWithInt:row]];
        [_bulbCols addObject:[NSNumber numberWithInt:col]];
        newComponent = [[Bulb alloc] initWithFrame:label.frame];
    } else if ([typeIndicator isEqual:@"sw"]) {
        // switch case
        newComponent = [[Switch alloc] initWithFrame:label.frame AtRow:row AndCol:col];
        ((Switch*)newComponent).delegate = self;
    } else {
        return;
    }

    [label removeFromSuperview];
    [self addSubview:newComponent];
    [[_cells objectAtIndex:row] setObject:newComponent atIndex:col];
}

- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)orientation
{
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
    
    [self.delegate performSelector:@selector(switchSelectedAtPosition:WithOrientation:) withObject:position withObject:orientation];
}

- (void) wireSelected:(id)sender
{
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
}

- (void) powerUp:(id)sender
{
    // turn on all battery components
    for (int i = 0; i < _batCols.count; ++i) {
        int batRow = [_batRows[i] intValue];
        int batCol = [_batCols[i] intValue];
        [(Battery*)[[_cells objectAtIndex:batRow] objectAtIndex:batCol] turnedOn];
    }
    
    [self.delegate performSelector:@selector(powerOn)];
}


- (void) bulbConnectedWithIndices: (NSArray*) bulbs{
    // turn off all bulbs first
    for (int i = 0; i < _bulbRows.count; ++i)
    {
        int bulbRow = [_bulbRows[i] intValue];
        int bulbCol = [_bulbCols[i] intValue];
        [(Bulb*)[[_cells objectAtIndex:bulbRow] objectAtIndex:bulbCol] lightDown];
    }
    
    // turn on all connected bulbs
    for (int j = 0; j < bulbs.count; ++j)
    {
        int index = [bulbs[j] integerValue];
        int bulbRow = [_bulbRows[index] intValue];
        int bulbCol = [_bulbCols[index] intValue];
        [(Bulb*)[[_cells objectAtIndex:bulbRow] objectAtIndex:bulbCol] lightUp];
    }
}

- (void) shorted {
    // explode all battery components
    for (int i = 0; i < _batCols.count; ++i)
    {
        int batRow = [_batRows[i] intValue];
        int batCol = [_batCols[i] intValue];
        [(Battery*)[[_cells objectAtIndex:batRow] objectAtIndex:batCol] exploded];
    }
}

@end
