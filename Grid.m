
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
<<<<<<< HEAD
    NSMutableArray *bulbs;
    NSMutableArray *bombs;
    NSMutableArray *cells;
    NSMutableArray *switches;
    
=======
    NSMutableArray *_bulbs;
    NSMutableArray *_bombs;
    NSMutableArray *_batteries;
    NSMutableArray *_cells;
>>>>>>> PowerUP
    //Lasers
    NSMutableArray *_lasers;
    NSMutableArray *_emitters;
    NSMutableArray *_deflectors;
    NSMutableArray *_receivers;
    
<<<<<<< HEAD
    CGFloat cellSize;
    
    Battery *battery;
    
    AVAudioPlayer* _audioPlayerPressed;
=======
    CGFloat _cellSize;
    
    AVAudioPlayer *_audioPlayerPressed;
>>>>>>> PowerUP
}
@end

@implementation Grid

#pragma mark - Initialization


- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    _numRows = rows;
    _numCols = cols;
<<<<<<< HEAD
=======
    
    //initialize _cells 2-D array
    _cells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _numRows; ++i) {
        NSMutableArray *rowCells = [[NSMutableArray alloc] init];
        [_cells addObject:rowCells];
    }
>>>>>>> PowerUP

    [self setUpGrid];
    
    // sound set up
    NSString *pressedPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *pressedPathURL = [NSURL fileURLWithPath : pressedPath];
    _audioPlayerPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:pressedPathURL error:nil];
    
    return self;
}

# pragma mark - Public Methods

- (void) setUpGrid {
    
    [self initializeAllArrays];
    
    [self populateGrid];
}

- (void) clearGrid {
    
    for (NSArray *row in cells) {
        for(Component *component in row) {
            [component removeFromSuperview];
        }
    }
}

- (void) clearGridExceptAtRow:(int)row andCol:(int)col {
    for (int r = 0; r < _numRows; ++r) {
        for(int c= 0; c < _numCols; ++c) {
            if (row != r || col != c) {
                [cells[r][c] removeFromSuperview];
            }
        }
    }
}

- (void)setValueAtRow:(int)row Col:(int)col To:(enum COMPONENTS)componentType WithDirection:(enum DIRECTION)dir AndConnections:(NSString*)connections {
    UIView* prevComp = [[cells objectAtIndex:row] objectAtIndex:col];
    UIView* newComponent;
    
    switch (componentType) {
        case WIRE:
            newComponent = [[Wire alloc] initWithFrame:prevComp.frame andConnections:connections];
            break;
            
        case BATTERY_NEG:
            newComponent = [[Battery alloc] initWithFrame:prevComp.frame AtRow:row AndCol:col AndPolarity:NO WithConnections:connections];
            ((Battery*)newComponent).delegate = self;
            battery = (Battery*)newComponent;
            break;
            
        case BATTERY_POS:
            newComponent = [[Battery alloc] initWithFrame:prevComp.frame AtRow:row AndCol:col AndPolarity:YES WithConnections:connections];
            ((Battery*)newComponent).delegate = self;
            break;
            
        case BULB:
            newComponent = [[Bulb alloc] initWithFrame:prevComp.frame];
            [bulbs addObject:newComponent];
            break;
            
        case SWITCH:
            newComponent = [[Switch alloc] initWithFrame:prevComp.frame AtRow:row AndCol:col WithConnections:connections];
            ((Switch*)newComponent).delegate = self;
            [switches addObject:newComponent];
            break;
            
        case EMITTER:
            newComponent = [[Emitter alloc] initWithFrame:prevComp.frame Direction:dir andConnections:connections];
            [_emitters addObject:newComponent];
            break;
            
        case DEFLECTOR:
            newComponent = [[Deflector alloc] initWithFrame:prevComp.frame AtRow:row AndCol:col WithConnections:connections];
            ((Deflector *)newComponent).delegate = self;
            [_deflectors addObject:newComponent];
            break;
            
        case RECEIVER:
            newComponent = [[Receiver alloc] initWithFrame:prevComp.frame Direction:dir andConnections:connections];
            [_receivers addObject:newComponent];
            break;
            
        case BOMB:
            newComponent = [[Bomb alloc] initWithFrame:prevComp.frame WithConnections:connections];
            [bombs addObject:newComponent];
            break;
            
        case LASER:
            newComponent = [[Laser alloc] initWithFrame:prevComp.frame WithConnections:connections];
            [_lasers addObject:newComponent];
            break;
            
        default:
            return;
    }
    
    [prevComp removeFromSuperview];
    [self addSubview:newComponent];
    [[cells objectAtIndex:row] setObject:newComponent atIndex:col];
}

- (void) turnOnAtRow:(int)row AndCol:(int)col {
    Component* component = cells[row][col];
    [component turnOn];
}

# pragma mark - Private Methods

- (void) initializeAllArrays {
    //initialize _cells 2-D array
    cells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _numRows; ++i) {
        NSMutableArray* rowCells = [[NSMutableArray alloc] init];
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
<<<<<<< HEAD
}

- (void) populateGrid {
=======
    
>>>>>>> PowerUP
    // calculate dimension of the cell that makes it fit in the frame
    CGFloat cellHeight = self.frame.size.height/_numRows;
    CGFloat cellWidth = self.frame.size.width/_numCols;
    _cellSize = MIN(cellHeight, cellWidth);
    
    // Set each cell on the grid
    for (int row = 0; row < _numRows; ++row){
        for (int col = 0; col < _numCols; ++col){
            
            // location of cell
            CGFloat xLabel = col * _cellSize;
            CGFloat yLabel = row * _cellSize;
            
            // initially set all cells to a clear label. Initialized to proper component later
<<<<<<< HEAD
            CGRect labelFrame = CGRectMake(xLabel, yLabel, cellSize, cellSize);
            UILabel* blankTile = [[UILabel alloc] initWithFrame:labelFrame];
=======
            CGRect labelFrame = CGRectMake(xLabel, yLabel, _cellSize, _cellSize);
            UILabel *blankTile = [[UILabel alloc] initWithFrame:labelFrame];
>>>>>>> PowerUP
            
            [self addSubview:blankTile];
            [cells[row] addObject:blankTile];
        }
    }
}

<<<<<<< HEAD
- (void) switchChangedAtPosition:(NSNumber*)position WithConnections:(NSString*)connections {
=======
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
    // white label to replace
    UIView *label = [[_cells objectAtIndex:row] objectAtIndex:col];

    // new component to replace with
    UIView *newComponent;
    
    // check component type and use the appropriate object
    NSString *typeIndicator = [componentType substringWithRange:NSMakeRange(0, 2)];
    
    if ([typeIndicator isEqual: @"wi"]) {
        // wire case
        newComponent = [[Wire alloc] initWithFrame:label.frame andOrientation:componentType];
        
    } else if ([typeIndicator isEqual:@"ba"]) {
        // battery case
        newComponent = [[Battery alloc]initWithFrame:label.frame andOrientation:componentType AtRow:row AndCol:col];
        ((Battery *)newComponent).delegate = self;
        
        [_batteries addObject:newComponent];
    } else if ([typeIndicator isEqual:@"bu"]) {
        newComponent = [[Bulb alloc] initWithFrame:label.frame];
        [_bulbs addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"sw"]) {
        // switch case
        newComponent = [[Switch alloc] initWithFrame:label.frame AtRow:row AndCol:col];
        ((Switch *)newComponent).delegate = self;
        newComponent.tag = 70;
        
    } else if ([typeIndicator isEqual:@"em"]) {//emitter case
        newComponent = [[Emitter alloc] initWithFrame:label.frame andOrientation:componentType];
        [_emitters addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"de"]) {//deflector case
        newComponent = [[Deflector alloc] initWithFrame:label.frame AtRow:row AndCol:col];
        ((Deflector *)newComponent).delegate = self;
        [_deflectors addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"re"]) {//receiver case
        newComponent = [[Receiver alloc] initWithFrame:label.frame andOrientation:componentType];
        [_receivers addObject:newComponent];
    
    } else if ([typeIndicator isEqual:@"bo"]) {//bomb case
        newComponent = [[Bomb alloc] initWithFrame:label.frame andOrientation:componentType];
        [_bombs addObject:newComponent];
        
    } else if ([typeIndicator isEqual:@"la"]) { // laser case
        newComponent = [[Laser alloc] initWithFrame:label.frame andOrientation:componentType];
        [_lasers addObject:newComponent];
        
    } else {
        return;
    }

    [label removeFromSuperview];
    [self addSubview:newComponent];
    [[_cells objectAtIndex:row] setObject:newComponent atIndex:col];
}

- (CGFloat) getCellSize
{
    return _cellSize;
}

- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)orientation
{
>>>>>>> PowerUP
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
    
    NSLog(@"Parameters in grid. Position:%@, and connection:%@",position, connections);
    [self.delegate performSelector:@selector(componentAdjustedAtPosition:WithConnections:) withObject:position withObject:connections];
}

//- (void) bulbConnectedWithIndices: (NSArray*) bulbs{
//    // turn off all bulbs first
//    for (int i = 0; i < bulbs.count; ++i)
//    {
//        [bulbs[i] turnOff];
//    }
//    
//    // turn on all connected bulbs
//    for (int j = 0; j < bulbs.count; ++j)
//    {
//        int index = [bulbs[j] intValue];
//        [bulbs[index] turnOn];
//    }
//}

- (void) powerUp:(id)sender {
    [self.delegate performSelector:@selector(masterPowerSelected)];
}

//- (void) setStateAtRow:(int)row AndCol:(int)col to:(BOOL)state
//{
//    if (state) {
//        [cells[row][col] turnOn];
//    } else {
//        [cells[row][col] turnOff];
//    }
//}

- (void) resetLasers
{
    for (int i = 0; i < _lasers.count; ++i){
        [_lasers[i] removeFromSuperview];
    }
    
    [_lasers removeAllObjects];
}

//- (void) shorted {
//    // explode all battery components
//    for (int i = 0; i < batteries.count; ++i)
//    {
//        [batteries[i] exploded];
//    }
//}

<<<<<<< HEAD
- (int) getBatteryX
{
    int pos = [battery getPosition];
    return (cellSize * (pos%100));
}

- (int) getBatteryY {
    int pos = [battery getPosition];
    return (cellSize * (pos/100));
}

- (int) getBombXAtRow:(int)row AndCol:(int)col
{
    return (cellSize * row);
}

- (int) getBombYAtRow:(int)row AndCol:(int)col
{
    return (cellSize * col);
}

//-(void)componentsTurnedOff
//{
//    for (int i = 0; i < _receivers.count; ++i)
//    {
//        [_receivers[i] turnOff];
//    }
//    
//    for (int i = 0; i < _emitters.count; ++i)
//    {
//        [_emitters[i] turnOff];
//    }
//    
//    for (int i = 0; i < _deflectors.count; ++i)
//    {
//        [_deflectors[i] turnOff];
//    }
//    
//    for (int i = 0; i < bulbs.count; ++i)
//    {
//        [bulbs[i] turnOff];
//    }
//    
//    // turn off all battery components
//    for (int i = 0; i < batteries.count; ++i)
//    {
//        [batteries[i] turnedOff];
//    }
//}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    for(Switch *view in switches){
        
=======
//Tags: Switches are 70-74
// -0 means that normal/ has not been touched yet
// -1 means touch started outside of view and is now inside of view
// -2 means that touch started outside of view, went inside of view and has now exited view
// -3 means that touch started inside of view and is still inside of view
// -4 means that touch started inside of view and has now exited view

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    for(Switch *view in self.subviews){
>>>>>>> PowerUP
        // touch begins inside a switch
        if([view touchState] == UNTOUCHED && CGRectContainsPoint(view.frame, location)){
            [view setTouchState:STARTED_IN_NOW_IN];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInView:self];
    CGPoint prevLocation = [[touches anyObject] previousLocationInView:self];
    
<<<<<<< HEAD
    for(Switch *view in switches){
=======
    for(Switch *view in self.subviews){
        
>>>>>>> PowerUP
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

<<<<<<< HEAD
=======
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
>>>>>>> PowerUP

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
