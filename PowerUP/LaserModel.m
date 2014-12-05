//
//  LaserModel.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-22.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "LaserModel.h"

@implementation LaserModel{
    NSArray* _grid;
    int _numRows;
    int _numCols;
    //the arrays holding the laser components for keeping track of their states
    NSMutableArray* _lasers;
    NSMutableArray* _emitters;
    NSMutableArray* _deflectors;
    NSMutableArray* _receivers;
}

/*
 *initialize the laser model with the grid along with its size
 */
- (id) initWithGrid:(NSArray *)grid numRow:(int)row numCol:(int)col
{
    _grid = grid;
    if (self = [super init]) {
        _numRows = row;
        _numCols = col;
        _lasers = [[NSMutableArray alloc] init];
        _emitters = [[NSMutableArray alloc] init];
        _deflectors = [[NSMutableArray alloc] init];
        _receivers = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 *adds a component to one of the component arrays
 *throws an exception if an invalid component is sent to this model
 */
- (void) addComponent:(ComponentModel*)component
{
    if ([[component getType] isEqual:@"emitter"]){
        [_emitters addObject:component];
    }else if([[component getType] isEqual:@"deflector"]){
        [_deflectors addObject:component];
    }else if([[component getType] isEqual:@"receiver"]){
        [_receivers addObject:component];
    }else{
        [NSException raise:@"Invalid component type added to laserModel" format:@"Component:%@ is invalid", [component getType]];
    }
}


- (BOOL) didEmitterStateChange:(NSArray*)states
{
    for (int i = 0; i < _emitters.count; ++i) {
        if ([states[i] boolValue] != [_emitters[i] getState]) {
            return YES;
        }
    }
    return NO;
}

/*
 * Given the current state of emitters, reset all the laser components
 * Input: N/A
 * Output: N/A
 */
- (void) updateLasers
{
    [self clearLasers];
    for(int i = 0; i<_deflectors.count; ++i){
        [_deflectors[i] setState:NO];
    }
    for(int i = 0; i<_receivers.count; ++i){
        [_receivers[i] setState:NO];
    }
    for(int i = 0; i<_emitters.count; ++i){
        [self createLaserPathFrom:_emitters[i]];
    }
}

/*
 *Reset the states of all components to be NO
 *Input: N/A
 *OutPut: N/A
 */
- (void) resetComponents
{
    for (ComponentModel* comp in _emitters){
        [comp setState:NO];
    }
    for (ComponentModel* comp in _deflectors){
        [comp setState:NO];
    }
    for (ComponentModel* comp in _receivers){
        [comp setState:NO];
    }
}

/*
 *Clear the component arrays
 */
- (void) clearLaserComponents
{
    [_emitters removeAllObjects];
    [_deflectors removeAllObjects];
    [_receivers removeAllObjects];
    [_lasers removeAllObjects];
}

/*
 *returns the emitter array
 */
- (NSArray*) getEmitters
{
    return _emitters;
}

/*
 *returns the deflector array
 */
- (NSArray*) getDeflectors
{
    return _deflectors;
}

/*
 *returns the receiver array
 */
- (NSArray*) getReceivers
{
    return _receivers;
}

/*
 *returns the laser array
 */
- (NSArray*) getLasers
{
    return _lasers;
}

/*
 * Clear the grid of the laser components and empty the array holding the lasers
 * Input: N/A
 * Output: N/A
 */
- (void) clearLasers
{
    for (int i = 0; i < _lasers.count; ++i) {
        int laserRow = [_lasers[i] getRow];
        int laserCol = [_lasers[i] getCol];
        
        ComponentModel* component = [[ComponentModel alloc] initOfType:@"empty" AtRow:laserRow AndCol:laserCol AndState:NO];
        _grid[laserRow][laserCol] = component;
    }

    [_lasers removeAllObjects];
    //return _lasers;
}

/*
 *gets a path for the laser emitted from a specific emitter with the specified direction
 */
- (void) createLaserPathFrom:(ComponentModel *)emitter
{
    int emRow = [emitter getRow];
    int emCol = [emitter getCol];
    if(emRow < 0 || emRow > _numRows-1 || emCol < 0 || emCol > _numCols-1){
        [NSException raise:@"Invalid emitter position" format:@"Position:%d,%d is invalid", emRow, emCol];
    }
    
    if([emitter getState]){
        NSString* dir = [emitter getDirection];
        
        if([dir isEqual:@"Top"]) {
            [self laserTopAtRow:emRow Col:emCol];
        } else if ([dir isEqual:@"Bottom"]) {
            [self laserBottomAtRow:emRow Col:emCol];
        } else if ([dir isEqual:@"Left"]) {
            [self laserLeftAtRow:emRow Col:emCol];
        } else if ([dir isEqual:@"Right"]) {
            [self laserRightAtRow:emRow Col:emCol];
        } else {
            
        }
    }
}

- (void) laserTopAtRow:(int)row Col:(int)col
{
    // draw the laser
    while ((row>0)&&([[_grid[row-1][col] getType] isEqual:@"empty"])){
        ComponentModel* comp = [[ComponentModel alloc] initOfType:@"laser" AtRow:row-1 AndCol:col AndState:YES];
        [comp connectedBottom:YES];
        [comp connectedTop:YES];
        _grid[row-1][col] = comp;
        [_lasers addObject:comp];
        --row;
    }
    // encountered an obstacle
    if (row != 0) {
        --row;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Bottom"];
    }
}


/*
 * Continuously draw a laser path downward from a specified location until you hit an obstacle
 * Input: Row and Col info
 * Output: N/A
 */
- (void) laserBottomAtRow:(int)row Col:(int)col
{
    // draw the laser
    while ((row<_numRows-1)&&([[_grid[row+1][col] getType] isEqual:@"empty"])){
        
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"laser" AtRow:row+1 AndCol:col AndState:YES];
        [comp connectedBottom:YES];
        [comp connectedTop:YES];
        _grid[row+1][col] = comp;
        [_lasers addObject:comp];
        ++row;
    }
    
    // encountered an obstacle
    if (row != _numRows-1) {
        ++row;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Top"];
    }
    
}

/*
 * Continuously draw a laser path to the left from a specified location until you an obstacle
 * Input: Row and Col info
 * Output: N/A
 */
- (void) laserLeftAtRow:(int)row Col:(int)col
{
    // draw the laser
    while ((col>0)&&([[_grid[row][col-1] getType] isEqual:@"empty"])){
        
        
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"laser" AtRow:row AndCol:col-1 AndState:YES];
        [comp connectedLeft:YES];
        [comp connectedRight:YES];
        _grid[row][col-1] = comp;
        [_lasers addObject:comp];
        --col;
    }
    
    // encountered an obstacle
    if (col != 0) {
        --col;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Right"];
    }
    
}


/*
 * Continuously draw a laser path to the right from a specified location until you an obstacle
 * Input: Row and Col info
 * Output: N/A
 */
- (void) laserRightAtRow:(int)row Col:(int)col
{
    // draw the laser
    while ((col<_numCols-1)&&([[_grid[row][col+1] getType] isEqual:@"empty"])){
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"laser" AtRow:row AndCol:col+1 AndState:YES];
        [comp connectedLeft:YES];
        [comp connectedRight:YES];
        _grid[row][col+1] = comp;
        [_lasers addObject:comp];
        ++col;
    }
    
    // encountered an obstacle
    if (col != _numCols-1) {
        ++col;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Left"];
    }
}

/*
 * Handle an object in the way of a laser
 * Input: Row and Col information of the obstacle and the direction from which it was encountered
 * Output: N/A
 */
- (void) encounteredObstacleAtRow:(int)row AndCol:(int)col From:(NSString*)dir
{
    
    ComponentModel *obstacle = _grid[row][col];
    
    // Handle the deflector case
    if ([[obstacle getType] isEqual:@"deflector"]) {
        
        // If the deflector is a state to continue the laser turn it on
        if ([obstacle isConnectedBottom] && [dir isEqual:@"Bottom"]) {
            [obstacle setState:YES];
        } else if ([obstacle isConnectedTop] && [dir isEqual:@"Top"]) {
            [obstacle setState:YES];
        } else if ([obstacle isConnectedLeft] && [dir isEqual:@"Left"]) {
            [obstacle setState:YES];
        } else if ([obstacle isConnectedRight] && [dir isEqual:@"Right"]) {
            [obstacle setState:YES];
        } else {
            return;
        }
        
        // Continue the beam in a direction specified by deflector
        if ([obstacle isConnectedBottom] && ![dir isEqual:@"Bottom"]) {
            [self laserBottomAtRow:row Col:col];
        }
        if ([obstacle isConnectedTop] && ![dir isEqual:@"Top"]) {
            [self laserTopAtRow:row Col:col];
        }
        if ([obstacle isConnectedLeft] && ![dir isEqual:@"Left"]) {
            [self laserLeftAtRow:row Col:col];
        }
        if ([obstacle isConnectedRight] && ![dir isEqual:@"Right"]) {
            [self laserRightAtRow:row Col:col];
        }
        
        // Handle the receiver case
    } else if ([[obstacle getType] isEqual:@"receiver"]) {
        
        if ([[obstacle getDirection] isEqual:dir]) {
            [obstacle setState:YES];
        }
        
        // Handle the bomb case
    } else if ([[obstacle getType] isEqual:@"bomb"]) {
        [obstacle setState:YES];
        
        // Other case
    } else {
        return;
    }
    
}


@end
