
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
    NSMutableArray *bulbs;
    NSMutableArray *bombs;
    NSMutableArray *cells;
    NSMutableArray *switches;

    //Lasers
    NSMutableArray *_lasers;
    NSMutableArray *_emitters;
    NSMutableArray *_deflectors;
    NSMutableArray *_receivers;
    
    CGFloat cellSize;
    
    Battery *battery;
    
    AVAudioPlayer *_audioPlayerPressed;
}
@end

@implementation Grid

const int EMPTYCELL = 0;

#pragma mark - Initialization


- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    _numRows = rows;
    _numCols = cols;

    CGFloat cellHeight = self.frame.size.height/_numRows;
    CGFloat cellWidth = self.frame.size.width/_numCols;
    cellSize = MIN(cellHeight, cellWidth);
    
    [self setUpGrid];
    
    // sound set up
    NSString *pressedPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *pressedPathURL = [NSURL fileURLWithPath : pressedPath];
    _audioPlayerPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:pressedPathURL error:nil];
    
    return self;
}

# pragma mark - Public Methods

- (void) setUpGrid {
    //initialize _cells 2-D array
    cells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _numRows; ++i) {
        NSMutableArray* rowCells = [[NSMutableArray alloc] init];
        for (int j = 0; j < _numCols; ++j) {
            [rowCells addObject:[NSNumber numberWithInt:EMPTYCELL]];
        }
        [cells addObject:rowCells];
    }
    
    // reset bat and bulb coordinates
    battery = [[Battery alloc] init];
    bulbs = [[NSMutableArray alloc] init];
    bombs = [[NSMutableArray alloc] init];
    switches = [[NSMutableArray alloc] init];
    _lasers = [[NSMutableArray alloc] init];
    _emitters = [[NSMutableArray alloc] init];
    _deflectors = [[NSMutableArray alloc] init];
    _receivers = [[NSMutableArray alloc] init];
}

- (void) clearGrid {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void) clearGridExceptAtRow:(int)row andCol:(int)col {
    for (int r = 0; r < _numRows; ++r) {
        for(int c= 0; c < _numCols; ++c) {
            
            if ((row != r || col != c) && cells[r][c] != [NSNumber numberWithInt:EMPTYCELL]) {
                
                [cells[r][c] removeFromSuperview];
                cells[r][c] = [NSNumber numberWithInt:EMPTYCELL];
            }
        }
    }
}

- (void)setValueAtRow:(int)row Col:(int)col To:(enum COMPONENTS)componentType WithDirection:(enum DIRECTION)dir AndConnections:(NSString*)connections {
    UIView* newComponent;
    
    CGFloat xPos = col * cellSize;
    CGFloat yPos = row * cellSize;
    CGRect labelFrame = CGRectMake(xPos, yPos, cellSize, cellSize);
    
    switch (componentType) {
        case WIRE:
            newComponent = [[Wire alloc] initWithFrame:labelFrame andConnections:connections];
            break;
            
        case BATTERY_NEG:
            newComponent = [[Battery alloc] initWithFrame:labelFrame AtRow:row AndCol:col AndPolarity:NO WithConnections:connections];
            ((Battery*)newComponent).delegate = self;
            battery = (Battery*)newComponent;
            break;
            
        case BATTERY_POS:
            newComponent = [[Battery alloc] initWithFrame:labelFrame AtRow:row AndCol:col AndPolarity:YES WithConnections:connections];
            ((Battery*)newComponent).delegate = self;
            break;
            
        case BULB:
            newComponent = [[Bulb alloc] initWithFrame:labelFrame];
            [bulbs addObject:newComponent];
            break;
            
        case SWITCH:
            newComponent = [[Switch alloc] initWithFrame:labelFrame AtRow:row AndCol:col WithConnections:connections];
            ((Switch*)newComponent).delegate = self;
            [switches addObject:newComponent];
            break;
            
        case EMITTER:
            newComponent = [[Emitter alloc] initWithFrame:labelFrame Direction:dir andConnections:connections];
            [_emitters addObject:newComponent];
            break;
            
        case DEFLECTOR:
            newComponent = [[Deflector alloc] initWithFrame:labelFrame AtRow:row AndCol:col WithConnections:connections];
            ((Deflector *)newComponent).delegate = self;
            [_deflectors addObject:newComponent];
            break;
            
        case RECEIVER:
            newComponent = [[Receiver alloc] initWithFrame:labelFrame Direction:dir andConnections:connections];
            [_receivers addObject:newComponent];
            break;
            
        case BOMB:
            newComponent = [[Bomb alloc] initWithFrame:labelFrame WithConnections:connections];
            [bombs addObject:newComponent];
            break;
            
        case LASER:
            newComponent = [[Laser alloc] initWithFrame:labelFrame WithConnections:connections];
            [_lasers addObject:newComponent];
            break;
            
        default:
            return;
    }
    
    if (cells[row][col] != [NSNumber numberWithInt:EMPTYCELL]) {
        [cells[row][col] removeFromSuperview];
    }

    [self addSubview:newComponent];
    [[cells objectAtIndex:row] setObject:newComponent atIndex:col];
}

- (void) turnOnAtRow:(int)row AndCol:(int)col {
    Component* component = cells[row][col];
    [component turnOn];
}

- (CGFloat) getCellSize
{
    return cellSize;
}


# pragma mark - Private Methods

- (void) switchChangedAtPosition:(NSNumber*)position WithConnections:(NSString*)connections {
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
    
    [self.delegate performSelector:@selector(componentSelectedAtPosition:WithConnections:) withObject:position withObject:connections];
}

- (void) deflectorSelectedAtPosition:(NSNumber*)position WithConnections:(NSString *)connections {
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
    
    [self.delegate performSelector:@selector(componentSelectedAtPosition:WithConnections:) withObject:position withObject:connections];
}

- (void) deflectorAdjustedAtPosition:(NSNumber*)position ToConnection:(NSString*)connections {
    [_audioPlayerPressed prepareToPlay];
    [_audioPlayerPressed play];
    
    [self.delegate performSelector:@selector(componentAdjustedAtPosition:WithConnections:) withObject:position withObject:connections];
}

- (void) powerUp:(id)sender {
    [self.delegate performSelector:@selector(masterPowerSelected)];
}

- (void) resetLasers
{
    for (int i = 0; i < _lasers.count; ++i){
        [_lasers[i] removeFromSuperview];
    }
    
    [_lasers removeAllObjects];
}


#pragma mark - Touch Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    for(Switch *view in switches){

        // touch begins inside a switch
        if([view touchState] == UNTOUCHED && CGRectContainsPoint(view.frame, location)){
            [view setTouchState:STARTED_IN_NOW_IN];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInView:self];
    CGPoint prevLocation = [[touches anyObject] previousLocationInView:self];
    
    for(Switch *view in switches){

        // touch has entered a switch
        if([view touchState] == UNTOUCHED && CGRectContainsPoint(view.frame, location)){
            
            [self touchEntersSwitch:view From:prevLocation];
            
            // touch has entered and exited a switch
        } else if([view touchState] == STARTED_OUT_NOW_IN && CGRectContainsPoint(view.frame, prevLocation) && !CGRectContainsPoint(view.frame, location)){
            
            [self touchEnteredAndExitedSwitch:view From:prevLocation To:location];
            
            // touch has entered, exited and re-entered a switch
        } else if([view touchState] == STARTED_OUT_WAS_IN_NOW_OUT && CGRectContainsPoint(view.frame, location)) {
            
            [self touchEnteredExitedAndEnteredSwitch:view];
            
            // touch started in a switch and has now exited
        } else if([view touchState] == STARTED_IN_NOW_IN && CGRectContainsPoint(view.frame, prevLocation) && !CGRectContainsPoint(view.frame, location)){
            
            [self touchStartedAndExitedFromSwitch:view AtLocation:location];
            
            // touch has started in a switch, exited and now re-entered
        } else if([view touchState] == STARTED_IN_NOW_OUT && CGRectContainsPoint(view.frame, location)){
            
            [self touchStartedExitedAndEnteredSwitch:view];
        }
    }
}

- (void) touchEntersSwitch:(Switch*)view From:(CGPoint)prevLocation {
    
    if (prevLocation.x < view.frame.origin.x) {
        [view setTouchEnteredDir:LEFT];
    }else if (prevLocation.x > view.frame.origin.x + view.frame.size.width) {
        [view setTouchEnteredDir:RIGHT];
    }else if (prevLocation.y < view.frame.origin.y) {
        [view setTouchEnteredDir:TOP];
    }else if (prevLocation.y > view.frame.origin.y + view.frame.size.height) {
        [view setTouchEnteredDir:BOTTOM];
    }
    [view tempAddEnteredDirection];
    [view setTouchState:STARTED_OUT_NOW_IN];
}

- (void) touchEnteredAndExitedSwitch:(Switch*)view From:(CGPoint)prevLocation To:(CGPoint)location {
    
    if (location.x < view.frame.origin.x) {
        [view setTouchExitedDir:LEFT];
    }else if (location.x > view.frame.origin.x + view.frame.size.width) {
        [view setTouchExitedDir:RIGHT];
    }else if (location.y < view.frame.origin.y) {
        [view setTouchExitedDir:TOP];
    }else if (location.y > view.frame.origin.y + view.frame.size.height) {
        [view setTouchExitedDir:BOTTOM];
    }
    if ([view touchExitedDir] == [view touchEnteredDir]) {
        [view tempRemoveEnteredDirection];
        [view setTouchExitedDir:NONE];
        [view setTouchEnteredDir:NONE];
        [view setTouchState:UNTOUCHED];
    } else {
        [view tempAddExitedDirection];
        [view setTouchState:STARTED_OUT_WAS_IN_NOW_OUT];
    }
}

- (void) touchEnteredExitedAndEnteredSwitch:(Switch*)view {
    [view tempRemoveExitedDirection];
    [view setTouchExitedDir:NONE];
    [view setTouchState:STARTED_OUT_NOW_IN];
}

- (void) touchStartedAndExitedFromSwitch:(Switch*)view AtLocation:(CGPoint)location {
    if (location.x < view.frame.origin.x) {
        [view setTouchExitedDir:LEFT];
    }else if (location.x > view.frame.origin.x + view.frame.size.width) {
        [view setTouchExitedDir:RIGHT];
    }else if (location.y < view.frame.origin.y) {
        [view setTouchExitedDir:TOP];
    }else if (location.y > view.frame.origin.y + view.frame.size.height) {
        [view setTouchExitedDir:BOTTOM];
    }
    [view tempAddExitedDirection];
    [view setTouchState:STARTED_IN_NOW_OUT];
}

- (void) touchStartedExitedAndEnteredSwitch:(Switch*)view {
    [view tempRemoveExitedDirection];
    [view setTouchExitedDir:NONE];
    [view setTouchState:STARTED_IN_NOW_IN];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    for(Switch* view in switches){
        if([view touchState] == STARTED_OUT_NOW_IN){
            [view addEnteredDirection];
        } else if ([view touchState] == STARTED_OUT_WAS_IN_NOW_OUT){
            [view addEnteredDirection];
            [view addExitedDirection];
        } else if ([view touchState] == STARTED_IN_NOW_OUT){
            [view addExitedDirection];
        } else if ([view touchState] == STARTED_IN_NOW_IN && touch.tapCount == 1){
            [view resetDirection];
        }
        [view setTouchEnteredDir:NONE];
        [view setTouchExitedDir:NONE];
        [view setTouchState:UNTOUCHED];
    }
}

@end
