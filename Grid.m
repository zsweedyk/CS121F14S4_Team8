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
#import "Emitter.h"
#import "Receiver.h"
#import "Laser.h"
#import "Deflector.h"

#import "Bomb.h"
#import "ExplosionScene.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Grid()
{
    int _numRows;
    int _numCols;
    
    // components
    NSMutableArray *_bulbs;
    NSMutableArray *_bombs;
    NSMutableArray *_batteries;
    NSMutableArray *_cells;
    //Lasers
    NSMutableArray *_lasers;
    NSMutableArray *_emitters;
    NSMutableArray *_deflectors;
    NSMutableArray *_receivers;
    
    CGFloat _cellSize;
    
    AVAudioPlayer *_audioPlayerPressed;
}
@end

@implementation Grid

const int EMPTYCELL = 0;

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
    
    CGFloat cellHeight = self.frame.size.height/_numRows;
    CGFloat cellWidth = self.frame.size.width/_numCols;
    _cellSize = MIN(cellHeight, cellWidth);

    [self setUpGrid];
    
    _lasers = [[NSMutableArray alloc] init];
    
    // sound set up
    NSString *pressedPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *pressedPathURL = [NSURL fileURLWithPath : pressedPath];
    _audioPlayerPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:pressedPathURL error:nil];
    
    return self;
}

- (void) setUpGrid
{
    // reset bat and bulb coordinates
    _batteries = [[NSMutableArray alloc] init];
    _bulbs = [[NSMutableArray alloc] init];
    _bombs = [[NSMutableArray alloc] init];
    _lasers = [[NSMutableArray alloc] init];
    _emitters = [[NSMutableArray alloc] init];
    _deflectors = [[NSMutableArray alloc] init];
    _receivers = [[NSMutableArray alloc] init];
    
    //initialize _cells 2-D array
    _cells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _numRows; ++i) {
        NSMutableArray* rowCells = [[NSMutableArray alloc] init];
        for (int j = 0; j < _numCols; ++j) {
            [rowCells addObject:[NSNumber numberWithInt:EMPTYCELL]];
        }
        [_cells addObject:rowCells];
    }
    
}

- (void) clearGrid {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

// components table:
// 0: blank
// 1: wire
// 3: negative battery
// 6: positive battery
// 4: bulb
// 7: switch
// 9: bomb
- (void)setValueAtRow:(int)row col:(int)col to:(NSString*)componentType
{
    // new component to replace with
    UIView* newComponent;
    
    CGFloat xPos = col * _cellSize;
    CGFloat yPos = row * _cellSize;
    CGRect labelFrame = CGRectMake(xPos, yPos, _cellSize, _cellSize);
    
    // check component type and use the appropriate object
    NSString *typeIndicator = [componentType substringWithRange:NSMakeRange(0, 2)];
    
    if ([typeIndicator isEqual: @"wi"]) {
        // wire case
        newComponent = [[Wire alloc] initWithFrame:labelFrame andOrientation:componentType];
        
    } else if ([typeIndicator isEqual:@"ba"]) {
        // battery case
        newComponent = [[Battery alloc]initWithFrame:labelFrame andOrientation:componentType AtRow:row AndCol:col];
        ((Battery *)newComponent).delegate = self;
        
        [_batteries addObject:newComponent];
    } else if ([typeIndicator isEqual:@"bu"]) {
        newComponent = [[Bulb alloc] initWithFrame:labelFrame];
        [_bulbs addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"sw"]) {
        // switch case
        newComponent = [[Switch alloc] initWithFrame:labelFrame AtRow:row AndCol:col];
        ((Switch *)newComponent).delegate = self;
        newComponent.tag = 70;
        
    } else if ([typeIndicator isEqual:@"em"]) {
        // emitter case
        newComponent = [[Emitter alloc] initWithFrame:labelFrame andOrientation:componentType];
        [_emitters addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"de"]) {
        // deflector case
        newComponent = [[Deflector alloc] initWithFrame:labelFrame AtRow:row AndCol:col];
        ((Deflector *)newComponent).delegate = self;
        [_deflectors addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"re"]) {
        // receiver case
        newComponent = [[Receiver alloc] initWithFrame:labelFrame andOrientation:componentType];
        [_receivers addObject:newComponent];
    
    } else if ([typeIndicator isEqual:@"bo"]) {
        // bomb case
        newComponent = [[Bomb alloc] initWithFrame:labelFrame andOrientation:componentType];
        [_bombs addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"la"]) {
        // laser case
        newComponent = [[Laser alloc] initWithFrame:labelFrame andOrientation:componentType];
        [_lasers addObject:newComponent];
        
    } else {
        return;
    }

    if (_cells[row][col] != [NSNumber numberWithInt:EMPTYCELL]) {
        [_cells[row][col] removeFromSuperview];
    }
    
    [self addSubview:newComponent];
    [[_cells objectAtIndex:row] setObject:newComponent atIndex:col];
}

- (CGFloat) getCellSize
{
    return _cellSize;
}

- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)orientation
{
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
    
    [self.delegate performSelector:@selector(componentSelectedAtPosition:WithOrientation:) withObject:position withObject:orientation];
}

- (void) wireSelected:(id)sender
{
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
}

- (void) deflectorSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)orientation
{
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
    
    [self.delegate performSelector:@selector(componentSelectedAtPosition:WithOrientation:) withObject:position withObject:orientation];
}

- (void) bulbConnectedWithIndices: (NSArray*) bulbs{
    // turn off all bulbs first
    for (int i = 0; i < _bulbs.count; ++i)
    {
        [_bulbs[i] turnOff];
    }
    
    // turn on all connected bulbs
    for (int j = 0; j < bulbs.count; ++j)
    {
        int index = [bulbs[j] intValue];
        [_bulbs[index] turnOn];
    }
}

- (void) powerUp:(id)sender
{
    // turn on all battery components
    for (int i = 0; i < _batteries.count; ++i) {
        [_batteries[i] turnedOn];
    }
    
    [self.delegate performSelector:@selector(masterPowerSelected)];
}

- (void) setStateAtRow:(int)row AndCol:(int)col to:(BOOL)state
{
    if (state) {
        [_cells[row][col] turnOn];
    } else {
        [_cells[row][col] turnOff];
    }
}

- (void) resetLasers
{
    for (int i = 0; i < _lasers.count; ++i){
        [_lasers[i] removeFromSuperview];
    }
    
    [_lasers removeAllObjects];
}


- (void) shorted {
    // explode all battery components
    for (int i = 0; i < _batteries.count; ++i)
    {
        [_batteries[i] exploded];
    }
}

//Tags: Switches are 70-74
// -0 means that normal/ has not been touched yet
// -1 means touch started outside of view and is now inside of view
// -2 means that touch started outside of view, went inside of view and has now exited view
// -3 means that touch started inside of view and is still inside of view
// -4 means that touch started inside of view and has now exited view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    for(Switch *view in self.subviews){
        // touch begins inside a switch
        if(view.tag == 70 && CGRectContainsPoint(view.frame, location)){
            view.tag = 73;
        }
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    CGPoint prevLocation = [[touches anyObject] previousLocationInView:self];
    
    for(Switch *view in self.subviews){
        
        // touch has entered a switch
        if(view.tag == 70 && CGRectContainsPoint(view.frame, location)){
            if (prevLocation.x < view.frame.origin.x) {
                view._enteredDir = @"L";
            }else if (prevLocation.x > view.frame.origin.x + view.frame.size.width) {
                view._enteredDir = @"R";
            }else if (prevLocation.y < view.frame.origin.y) {
                view._enteredDir = @"T";
            }else if (prevLocation.y > view.frame.origin.y + view.frame.size.height) {
                view._enteredDir = @"B";
            }
            [view addImageDirection:view._enteredDir];
            view.tag = 71;
            
            // touch has entered and exited a switch
        } else if(view.tag == 71 && CGRectContainsPoint(view.frame, prevLocation) && !CGRectContainsPoint(view.frame, location)){
            if (location.x < view.frame.origin.x) {
                view._exitedDir = @"L";
            }else if (location.x > view.frame.origin.x + view.frame.size.width) {
                view._exitedDir = @"R";
            }else if (location.y < view.frame.origin.y) {
                view._exitedDir = @"T";
            }else if (location.y > view.frame.origin.y + view.frame.size.height) {
                view._exitedDir = @"B";
            }
            if ([view._exitedDir isEqualToString:view._enteredDir]) {
                [view removeImageDirection:view._enteredDir];
                view._exitedDir = @"X";
                view._enteredDir = @"X";
                view.tag = 70;
            } else {
                [view addImageDirection:view._exitedDir];
                view.tag = 72;
            }
            
            // touch has entered, exited and re-entered a switch
        } else if(view.tag == 72 && CGRectContainsPoint(view.frame, location)) {
            [view removeImageDirection:view._exitedDir];
            view._exitedDir = @"X";
            view.tag = 71;
            
            // touch started in a switch and has now exited
        } else if(view.tag == 73 && CGRectContainsPoint(view.frame, prevLocation) && !CGRectContainsPoint(view.frame, location)){
            if (location.x < view.frame.origin.x) {
                view._exitedDir = @"L";
            }else if (location.x > view.frame.origin.x + view.frame.size.width) {
                view._exitedDir = @"R";
            }else if (location.y < view.frame.origin.y) {
                view._exitedDir = @"T";
            }else if (location.y > view.frame.origin.y + view.frame.size.height) {
                view._exitedDir = @"B";
            }
            [view addImageDirection:view._exitedDir];
            view.tag = 74;
            
            // touch has started in a switch, exited and now re-entered
        } else if(view.tag == 74 && CGRectContainsPoint(view.frame, location)){
            [view removeImageDirection:view._exitedDir];
            view._exitedDir = @"X";
            view.tag = 73;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    for(Switch *view in self.subviews){
        if(view.tag == 71){
            [view addDirection:view._enteredDir];
            view._enteredDir = @"X";
            view.tag = 70;
        } else if (view.tag == 72){
            [view addDirection:view._enteredDir];
            [view addDirection:view._exitedDir];
            view._enteredDir = @"X";
            view._exitedDir = @"X";
            view.tag = 70;
        } else if (view.tag == 74){
            [view addDirection:view._exitedDir];
            view._exitedDir = @"X";
            view.tag = 70;
        } else if (view.tag == 73 && touch.tapCount == 1){
            [view resetDirection];
            view.tag = 70;
        }
    }
}

-(void)componentsTurnedOff
{
    for (int i = 0; i < _receivers.count; ++i)
    {
        [_receivers[i] turnOff];
    }
    
    for (int i = 0; i < _emitters.count; ++i)
    {
        [_emitters[i] turnOff];
    }
    
    for (int i = 0; i < _deflectors.count; ++i)
    {
        [_deflectors[i] turnOff];
    }
    
    for (int i = 0; i < _bulbs.count; ++i)
    {
        [_bulbs[i] turnOff];
    }
    
    // turn off all battery components
    for (int i = 0; i < _batteries.count; ++i)
    {
        [_batteries[i] turnedOff];
    }
}


@end
