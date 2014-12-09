//
//  LaserModel.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-22.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "GameLaserModel.h"
#import "EmitterModel.h"
#import "LaserModel.h"
#import "ReceiverModel.h"
#import "DeflectorModel.h"
#import "BombModel.h"

@implementation GameLaserModel{
    NSArray* grid;
    int rows;
    int cols;
}

/*
 *initialize the laser model with the grid along with its size
 */
- (id) initWithGrid:(NSArray *)initGrid numRow:(int)numRow numCol:(int)numCol
{
    grid = initGrid;
    if (self = [super init]) {
        rows = numRow;
        cols = numCol;
        self.lasers = [[NSMutableArray alloc] init];
        self.emitters = [[NSMutableArray alloc] init];
        self.deflectors = [[NSMutableArray alloc] init];
        self.receivers = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 *adds a component to one of the component arrays
 *throws an exception if an invalid component is sent to this model
 */
- (void) addComponent:(ComponentModel*)component
{
    switch ([component type]) {
        case EMITTER:
            [self.emitters addObject:component];
            break;
        case DEFLECTOR:
            [self.deflectors addObject:component];
            break;
        case RECEIVER:
            [self.receivers addObject:component];
            break;
        default:
            [NSException raise:@"Invalid Component" format:@"Component Input into laser model was invalid"];
            break;
    }
}


- (BOOL) didEmitterStateChange:(NSArray*)states
{
    for (int i = 0; i < self.emitters.count; ++i) {
        if ([states[i] boolValue] != [(EmitterModel*)self.emitters[i] state]) {
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
    
    for(int i = 0; i < self.emitters.count; ++i){
        [self createLaserPathFrom:self.emitters[i]];
    }
}

/*
 *Reset the states of all components to be NO
 *Input: N/A
 *OutPut: N/A
 */
- (void) resetComponents
{
    for (EmitterModel* comp in self.emitters){
        [comp setState:NO];
    }
    for (DeflectorModel* comp in self.deflectors){
        [comp setState:NO];
    }
    for (ReceiverModel* comp in self.receivers){
        [comp setState:NO];
    }
    
    [self clearLasers];
}

/*
 *Clear the component arrays
 */
- (void) clearLaserComponents
{
    [self.emitters removeAllObjects];
    [self.deflectors removeAllObjects];
    [self.receivers removeAllObjects];
    [self.lasers removeAllObjects];
}

/*
 * Clear the grid of the laser components and empty the array holding the lasers
 * Input: N/A
 * Output: N/A
 */
- (void) clearLasers
{
    for (int i = 0; i < self.lasers.count; ++i) {
        int laserRow = [self.lasers[i] row];
        int laserCol = [self.lasers[i] col];
        
        ComponentModel* component = [[ComponentModel alloc] initType:EMPTY AtRow:laserRow AndCol:laserCol WithState:NO];
        grid[laserRow][laserCol] = component;
    }

    [self.lasers removeAllObjects];
}

/*
 *gets a path for the laser emitted from a specific emitter with the specified direction
 */
- (void) createLaserPathFrom:(EmitterModel*)emitter
{
    int emRow = [emitter row];
    int emCol = [emitter col];
    
    if([emitter state]){
        enum DIRECTION dir = [emitter direction];
        
        switch (dir) {
            case LEFT:
                [self laserLeftAtRow:emRow Col:emCol];
                break;
            case RIGHT:
                [self laserRightAtRow:emRow Col:emCol];
                break;
            case TOP:
                [self laserTopAtRow:emRow Col:emCol];
                break;
            case BOTTOM:
                [self laserBottomAtRow:emRow Col:emCol];
                break;
            default:
                break;
        }
    }
}

- (void) laserTopAtRow:(int)row Col:(int)col
{
    // draw the laser
    while (row > 0 && [(ComponentModel*)grid[row-1][col] type] == EMPTY) {
        
        ComponentModel* comp = [[LaserModel alloc] initType:LASER AtRow:row-1 AndCol:col WithState:NO];
        [comp setConnectedBottom:YES];
        [comp setConnectedTop:YES];
        
        grid[row-1][col] = comp;
        [self.lasers addObject:comp];
        --row;
    }
    // encountered an obstacle
    if (row != 0) {
        --row;
        [self encounteredObstacleAtRow:row AndCol:col From:BOTTOM];
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
    while ( row < rows-1 && [(ComponentModel*)grid[row+1][col] type] == EMPTY){
        
        ComponentModel *comp = [[LaserModel alloc] initType:LASER AtRow:row+1 AndCol:col WithState:NO];
        [comp setConnectedBottom:YES];
        [comp setConnectedTop:YES];
        
        grid[row+1][col] = comp;
        [self.lasers addObject:comp];
        ++row;
    }
    
    // encountered an obstacle
    if (row != rows-1) {
        ++row;
        [self encounteredObstacleAtRow:row AndCol:col From:TOP];
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
    while ( col > 0 && [(ComponentModel*)grid[row][col-1] type] == EMPTY ) {
        
        ComponentModel *comp = [[LaserModel alloc] initType:LASER AtRow:row AndCol:col-1 WithState:NO];
        [comp setConnectedLeft:YES];
        [comp setConnectedRight:YES];
        
        grid[row][col-1] = comp;
        [self.lasers addObject:comp];
        --col;
    }
    
    // encountered an obstacle
    if (col != 0) {
        --col;
        [self encounteredObstacleAtRow:row AndCol:col From:RIGHT];
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
    while ( col < cols - 1 && [(ComponentModel*)grid[row][col+1] type] == EMPTY ){
        ComponentModel *comp = [[LaserModel alloc] initType:LASER AtRow:row AndCol:col+1 WithState:NO];
        [comp setConnectedLeft:YES];
        [comp setConnectedRight:YES];
        
        grid[row][col+1] = comp;
        [self.lasers addObject:comp];
        ++col;
    }
    
    // encountered an obstacle
    if (col != cols-1) {
        ++col;
        [self encounteredObstacleAtRow:row AndCol:col From:LEFT];
    }
}

/*
 * Handle an object in the way of a laser
 * Input: Row and Col information of the obstacle and the direction from which it was encountered
 * Output: N/A
 */
- (void) encounteredObstacleAtRow:(int)row AndCol:(int)col From:(enum DIRECTION)dir
{
    
    ComponentModel *obstacle = grid[row][col];
    
    switch ([obstacle type]) {
        case DEFLECTOR:
            [self encounteredDeflector:(DeflectorModel*)obstacle From:dir AtRow:row AndCol:col];
            break;
        case RECEIVER:
            [self encounteredReceiver:(ReceiverModel*)obstacle From:dir];
            break;
        case BOMB:
            [self encounteredBomb:(BombModel*)obstacle];
            break;
        default:
            break;
    }
}

- (void) encounteredDeflector:(DeflectorModel*)deflector From:(enum DIRECTION)dir AtRow:(int)row AndCol:(int)col {
    
    // If the deflector is a state to continue the laser turn it on
    if ([deflector connectedBottom] && dir == BOTTOM) {
        [deflector setState:YES];
    } else if ([deflector connectedTop] && dir == TOP) {
        [deflector setState:YES];
    } else if ([deflector connectedLeft] && dir == LEFT) {
        [deflector setState:YES];
    } else if ([deflector connectedRight] && dir == RIGHT) {
        [deflector setState:YES];
    } else {
        return;
    }
    
    // Continue the beam in a direction specified by deflector
    if ([deflector connectedBottom] && dir != BOTTOM) {
        [self laserBottomAtRow:row Col:col];
    }
    if ([deflector connectedTop] && dir != TOP) {
        [self laserTopAtRow:row Col:col];
    }
    if ([deflector connectedLeft] && dir != LEFT) {
        [self laserLeftAtRow:row Col:col];
    }
    if ([deflector connectedRight] && dir != RIGHT) {
        [self laserRightAtRow:row Col:col];
    }
}

- (void) encounteredReceiver:(ReceiverModel*)receiver From:(enum DIRECTION)dir {
    if ([receiver direction] == dir) {
        [receiver setState:YES];
    }
}

- (void) encounteredBomb:(BombModel*)bomb {
    [bomb setState:YES];
}


@end
