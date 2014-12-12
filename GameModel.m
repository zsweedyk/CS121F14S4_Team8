//
//  GameModel.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Enums.h"
#import "GameModel.h"
#import "ComponentModel.h"
#import "WireModel.h"
#import "BatteryModel.h"
#import "BulbModel.h"
#import "SwitchModel.h"
#import "EmitterModel.h"
#import "ReceiverModel.h"
#import "DeflectorModel.h"
#import "BombModel.h"
#import "GameLaserModel.h"

@interface GameModel()
{

    NSMutableArray* grid;
    NSMutableArray* bulbs;
    NSMutableArray* bombs;
    
    BatteryModel* batteryPos;
    BatteryModel* batteryNeg;
    
    int _numLevels; // total number of levels
    
    GameLaserModel *laserModel;
}

@end

@implementation GameModel

const int numRows = 15;
const int numCols = 15;

# pragma mark - Initialization


/*
 * Init function
 * Input: the number of total levels we have
 * Output: GameModel object
 */
-(id) initWithTotalLevels:(int)totalLevels
{
    _numLevels = totalLevels;
    
    if (self = [super init]) {

        bulbs = [[NSMutableArray alloc] init];
        bombs = [[NSMutableArray alloc] init];

        grid = [[NSMutableArray alloc] init];
        self.rows = numRows;
        self.cols = numCols;
        
        laserModel = [[GameLaserModel alloc] initWithGrid:grid numRow:numRows numCol:numCols];
        // in each row spot add another array for the columns in the grid
        for (int r = 0; r < numRows; ++r) {
            NSMutableArray *column = [[NSMutableArray alloc] init];
            [grid addObject:column];
        }
    }
    
    return self;
}


/*
 * Gets a grid from the appropriate text file and fill in the Model grid and component tracking arrays with the appropriate components
 * Input: the level we want to model
 * Output: N/A
 */
-(void) generateGrid:(int) level
{
    [self clearGridAndComponents];
    
    // Make sure that the input for this method is valid
    NSAssert((level <= _numLevels), @"Invalid level argument");
    NSAssert((level >= -5), @"Invalid level argument"); // <--Adjust this when testing to allow for test grids.
    
    // get the grid data from the txt file
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"level%d",level] ofType:@""];
    NSError *error;
    NSString *data = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    // set the grid and component arrays
    [self setComponentsWithData:data];
    [self setConnectionsWithData:data];
    
    [self updateModel];
    [self updateGameStatus];
}


/*
 * Cleares the grid of everything and clears the component arrays
 * Input: N/A
 * Output: N/A
 */
-(void) clearGridAndComponents
{
    // grid clearing
    for (int x = 0; x < grid.count; ++x) {
        [grid[x] removeAllObjects];
    }
    
    // component array clearing
    [bulbs removeAllObjects];
    [bombs removeAllObjects];
    [laserModel clearLaserComponents];
}


/*
 * Sets all the components in the grid to right type of component
 * Input: Data from the text file
 * Ouput: N/A
 *
 * Component enum type table
 * 0: blank
 * 1: wire
 * 2: emitter
 * 3: negative battery
 * 4: bulb
 * 5: receiver
 * 6: positive battery
 * 7: switch
 * 8: deflector
 * 9: bomb
 */
- (void) setComponentsWithData:(NSString*)data
{
    for (int r = 0; r < numRows; ++r) {
        
        NSRange range = NSMakeRange(2*r*(2*numCols+1), 2*numCols-1); // the range for a row worth of data
        NSString *rowData = [data substringWithRange:range];

        for (int c = 0; c < numCols; ++c) {

            enum COMPONENTS datum = [[rowData substringWithRange:NSMakeRange(2*c, 1)] intValue]; // The component enum type for one grid location
            
            // set the types as appropriate
            ComponentModel* component;
            switch (datum) {
                case WIRE: {
                    component = [[WireModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [[grid objectAtIndex:r] addObject:component];
                    break;
                }
                case EMITTER: {
                    component = [[EmitterModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [[grid objectAtIndex:r] addObject:component];
                    [laserModel addComponent:component];
                    break;
                }
                case BATTERY_NEG: {
                    component = [[BatteryModel alloc] initType:datum AtRow:r AndCol:c WithState:NO Positive:NO];
                    batteryNeg = (BatteryModel*)component;
                    [[grid objectAtIndex:r] addObject:component];
                    break;
                }
                case BATTERY_POS: {
                    component = [[BatteryModel alloc] initType:datum AtRow:r AndCol:c WithState:NO Positive:YES];
                    batteryPos = (BatteryModel*)component;
                    [[grid objectAtIndex:r] addObject:component];
                    break;
                }
                case BULB: {
                    component = [[BulbModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [[grid objectAtIndex:r] addObject:component];
                    [bulbs addObject:component];
                    break;
                }
                case RECEIVER: {
                    component = [[ReceiverModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [[grid objectAtIndex:r] addObject:component];
                    [laserModel addComponent:component];
                    break;
                }
                case DEFLECTOR: {
                    component = [[DeflectorModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [[grid objectAtIndex:r] addObject:component];
                    [laserModel addComponent:component];
                    break;
                }
                case SWITCH: {
                    component = [[SwitchModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [[grid objectAtIndex:r] addObject:component];
                    break;
                }
                case BOMB: {
                    component = [[BombModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [bombs addObject:component];
                    [[grid objectAtIndex:r] addObject:component];
                    break;
                }
                case EMPTY: {
                    component = [[ComponentModel alloc] initType:datum AtRow:r AndCol:c WithState:NO];
                    [[grid objectAtIndex:r] addObject:component];
                    break;
                }
                default:
                    break;
            }
        }
    }
}


/*
 * Sets all the connections for the components
 * Input: Data from text file
 * Ouput: N/A
 */
- (void) setConnectionsWithData:(NSString*)data
{
    for (int r = 0; r < 2*numRows-2; ++r) {
        
        NSRange range = NSMakeRange(r*(2*numCols+1), 2*numCols-1); // range for a rows worth of data
        NSString* rowData = [data substringWithRange:range];

        for (int c = 0; c < 2*numCols-2; ++c) {
            
            NSString *datum = [rowData substringWithRange:NSMakeRange(c, 1)]; // One conenction type
            
            // Set the connections as appropriate
            if ([datum isEqual:@"-"]) {
                [[[grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] setConnectedRight:YES];
                [[[grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] setConnectedLeft:YES];
            } else if ([datum isEqual:@"|"]) {
                [[[grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] setConnectedBottom:YES];
                [[[grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] setConnectedTop:YES];
            } else if ([datum isEqual:@"+"]) {
                [[[grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] setDirection:RIGHT];
                [[[grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] setDirection:LEFT];
            } else if ([datum isEqual:@"*"]) {
                [[[grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] setDirection:BOTTOM];
                [[[grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] setDirection:TOP];
            }
        }
    }
}


# pragma mark - Public Methods

- (void) updateGameStatus {
    [self checkBomb];
    [self checkComplete];
    [self checkShort];
}

/*
 * Gets the type of component at a specified location including its connection suffix
 * Input: Row and Col information
 * Output: The component type
 */
-(enum COMPONENTS) getTypeAtRow:(int)row andCol:(int)col
{
    // Input validation
    NSAssert((row <= numRows) && (row >= 0), @"Invalid row argument");
    NSAssert((col >= 0) && (col <= numCols), @"Invalid col argument");
    
    ComponentModel *component = [[grid objectAtIndex:row] objectAtIndex:col];
    
    return [component type];
}

- (enum DIRECTION) getDirectionAtRow:(int)row andCol:(int)col {
    
    // Input validation
    NSAssert((row <= numRows) && (row >= 0), @"Invalid row argument");
    NSAssert((col >= 0) && (col <= numCols), @"Invalid col argument");
    
    ComponentModel *component = [[grid objectAtIndex:row] objectAtIndex:col];
    
    return [component direction];
}

- (NSString*) getConnectionAtRow:(int)row andCol:(int)col {
    ComponentModel *component = [[grid objectAtIndex:row] objectAtIndex:col];
    BOOL isSwitch = NO;
    
    if ([component type] == SWITCH) {
        isSwitch = YES;
    }
    
    NSString *connections = @"";
    // Check all 4 directions for conenctions
    if ( [component connectedLeft] || (!isSwitch && [self hasSwitchTo:LEFT OfRow:row andCol:col])) {
        connections = [connections stringByAppendingString:@"L"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if ( [component connectedRight] || (!isSwitch && [self hasSwitchTo:RIGHT OfRow:row andCol:col])) {
        connections = [connections stringByAppendingString:@"R"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if ( [component connectedTop] || (!isSwitch && [self hasSwitchTo:TOP OfRow:row andCol:col])) {
        connections = [connections stringByAppendingString:@"T"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if ( [component connectedBottom] || (!isSwitch && [self hasSwitchTo:BOTTOM OfRow:row andCol:col])) {
        connections = [connections stringByAppendingString:@"B"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    return connections;
}


- (BOOL) getStateAtRow:(int)row andCol:(int)col {
    ComponentModel* component = grid[row][col];
    
    return [component state];
}


/*
 * Adjust the model to a component being selected, specifically adjust the connections for the component and the components surrounding it
 * Input: The position of the component and its new orientation
 * Output: N/A
 */
-(void) componentSelectedAtRow:(int)row andCol:(int)col WithConnections:(NSString*)newConnections
{
    NSLog(@"Parameters in game model. row:%d, col:%d, and connection:%@",row, col, newConnections);
    // Input validation
    NSRegularExpression *orientationForm = [[NSRegularExpression alloc] initWithPattern:@"[LX][RX][TX][BX]" options:0 error:nil];
    NSUInteger numMatchesToForm = [orientationForm numberOfMatchesInString:newConnections options:0 range:NSMakeRange(0, 4)];
    NSAssert(numMatchesToForm == 1, @"Invalid orientation argument");
    NSAssert((row <= numRows) && (row >= 0), @"Invalid row argument");
    NSAssert((col >= 0) && (col <= numCols), @"Invalid col argument");
    
    ComponentModel* component = grid[row][col];
    // Adjust the connections in all 4 directions, keeping in mind the edge components
    if ( col != 0 ) {
        if ([[newConnections substringWithRange:NSMakeRange(0, 1)] isEqual:@"L"]) {
            [component setConnectedLeft:YES];
            [grid[row][col - 1] setConnectedRight:YES];
        } else {
            [component setConnectedLeft:NO];
            [grid[row][col - 1] setConnectedRight:NO];
        }
    }
    
    if ( col != numCols-1 ) {
        if ([[newConnections substringWithRange:NSMakeRange(1, 1)] isEqual:@"R"]) {
            [component setConnectedRight:YES];
            [grid[row][col + 1] setConnectedLeft:YES];
        } else {
            [component setConnectedRight:NO];
            [grid[row][col + 1] setConnectedLeft:NO];
        }
    }
    
    if (row != 0) {
        if ([[newConnections substringWithRange:NSMakeRange(2, 1)] isEqual:@"T"]) {
            [component setConnectedTop:YES];
            [grid[row - 1][col] setConnectedBottom:YES];
        } else {
            [component setConnectedTop:NO];
            [grid[row - 1][col] setConnectedBottom:NO];
        }
    }
    
    if (row != numRows - 1) {
        if ([[newConnections substringWithRange:NSMakeRange(3, 1)] isEqual:@"B"]) {
            [component setConnectedBottom:YES];
            [grid[row + 1][col] setConnectedTop:YES];
        } else {
            [component setConnectedBottom:NO];
            [grid[row + 1][col] setConnectedTop:NO];
        }
    }

    [self updateModel];
    [self updateGameStatus];
}

#pragma mark - Private Methods

- (void) updateModel {
    
    [self resetComponents];
    [self updateEmitters];
    
    // With the laser components theres a possibility that certain updates can induce changes in more components
    // Therefore we loop until there are no more differences.
    while (true) {
        
        [self updateLasers];
        [self updateBulbs];
        [self updateBombs];
        
        NSArray* emitterStates = [self stateOf:[laserModel emitters]];
        [self updateEmitters];
        if (![laserModel didEmitterStateChange:emitterStates]) {
            break;
        }
    }
}


/*
 * Reset all the changing components
 * Input: N/A
 * Output: N/A
 */
- (void) resetComponents
{
    [self reset:bulbs];
    [self reset:bombs];
    [laserModel resetComponents];
}


/*
 * Turn off the states of components in inputted array
 * Input: Array of components to 'turn off'
 * Output: N/A
 */
- (void) reset:(NSArray*)components
{
    for (ComponentModel* comp in components) {
        [comp setState:NO];
    }
}

- (void) updateBulbs {
    [self updateStateOfComponents:bulbs];
}

- (void) updateBombs {
    [self updateStateOfComponents:bombs];
}

- (void) updateEmitters {
    NSArray* emitters = [laserModel emitters];
    [self updateStateOfComponents:emitters];
}

- (void) updateLasers {
    [laserModel updateLasers];
}


- (void) updateStateOfComponents:(NSArray*)components
{
    for (ComponentModel* comp in components) {
        
        // Reset all the components
        NSArray* connections = [self getAllConnectionsTo:comp];
        
        // Bomb can have connections less than 2
        if (connections.count < 2) {
            if ([comp type] != BOMB){
                [comp setState:NO];
            }
            continue;
        }
        
        NSAssert(connections.count == 2, @"Invalid connection count");
        
        // Check if the component is connected by battery following the two possible paths
        BOOL path1Pos = [self breadthSearchFrom:comp To:batteryPos inDirection:[connections[0] intValue] CheckingForShort:NO];
        BOOL path1Neg = [self breadthSearchFrom:comp To:batteryNeg inDirection:[connections[1] intValue] CheckingForShort:NO];
        BOOL path2Neg = [self breadthSearchFrom:comp To:batteryNeg inDirection:[connections[0] intValue] CheckingForShort:NO];
        BOOL path2Pos = [self breadthSearchFrom:comp To:batteryPos inDirection:[connections[1] intValue] CheckingForShort:NO];
        
        // If one of paths is there, set the state to on
        if ((path1Pos && path1Neg) || (path2Pos && path2Neg)) {
            [comp setState:YES];
            continue;
        }
        
        // Now check if the component is connected by a receiver that is on
        if ([comp type] != RECEIVER) {
            NSArray* receivers = [laserModel receivers];
            for (int j = 0; j < receivers.count; ++j){
                
                BOOL path1 = [self breadthSearchFrom:comp To:receivers[j] inDirection:[connections[0] intValue] CheckingForShort:NO];
                BOOL path2 = [self breadthSearchFrom:comp To:receivers[j] inDirection:[connections[1] intValue] CheckingForShort:NO];
                
                if (path1 && path2 && [(ReceiverModel*)receivers[j] state] ) {
                    [comp setState:YES];
                }
            }
        }
    }
}


/*
 * Gets all the connections to a specified component
 * Input: The component
 * Output: An array of all the connection direction
 */
- (NSArray*) getAllConnectionsTo:(ComponentModel*)component
{

    NSMutableArray* connections = [[NSMutableArray alloc] init];
    
    if ( [component connectedLeft] ) {
        [connections addObject:[NSNumber numberWithInt:LEFT]];
    }
    if ( [component connectedRight] ) {
        [connections addObject:[NSNumber numberWithInt:RIGHT]];
    }
    if ( [component connectedTop] ) {
        [connections addObject:[NSNumber numberWithInt:TOP]];
    }
    if ( [component connectedBottom] ) {
        [connections addObject:[NSNumber numberWithInt:BOTTOM]];
    }
    
    return connections;
}


/*
 * Gets the current states of a specified list of component
 * Input: The components
 * Output: An array representing the current state of components
 */
- (NSArray*) stateOf:(NSArray*)components
{
    NSMutableArray *states = [[NSMutableArray alloc] init];
    for (ComponentModel *comp in components) {
        [states addObject:[NSNumber numberWithBool:[comp state]]];
    }
    
    return states;
}


- (void) checkShort {
    self.shorted = [self breadthSearchFrom:batteryNeg To:batteryPos inDirection:RIGHT CheckingForShort:YES];
}

- (void) checkBomb {
    for (BombModel *bomb in bombs) {
        if ([bomb state]) {
            self.exploded = YES;
            return;
        }
    }
    self.exploded = NO;
}

- (void) checkComplete {
    for (BulbModel *bulb in bulbs) {
        if (![bulb state]) {
            
            self.complete = NO;
            [batteryPos setState:NO];
            [batteryPos setState:NO];
            return;
        }
    }
    
    self.complete = YES;
    [batteryNeg setState:YES];
    [batteryPos setState:YES];
}


/*
 * Gets a list of bombs that should be detonated
 * Input: N/A
 * Output: An array of bombs
 */
- (NSArray*) getConnectedBombs
{
    return [self getConnectedLocations:bombs withState:NO];
}


/*
 * Gets batteries
 * Input: N/A
 * Output: An array of batteries
 */
-(NSArray*) getBatteries
{
    NSMutableArray *batteries = [[NSMutableArray alloc] init];
    [batteries addObject:batteryNeg];
    [batteries addObject:batteryPos];
    return [self getConnectedLocations:batteries withState:YES];
}

/*
 * Gets a list of lasers that should be present on the grid
 * Input: N/A
 * Output: An array of lasers
 */
-(NSArray*) getLasers
{
    NSMutableArray *laserPositions = [[NSMutableArray alloc] init];
    
    for (ComponentModel *laser in [laserModel lasers]) {
        [laserPositions addObject:[NSNumber numberWithInt:100*[laser row] + [laser col]]];
    }
    
    return laserPositions;
}

/*
 * Tells you a component has a switch to a specified direction of a specified component
 * Input: The component and direction to look
 * Output: Boolean for whether the component has a switch to that direction
 */
- (BOOL) hasSwitchTo:(enum DIRECTION)direction OfRow:(int)row andCol:(int)col {
    switch (direction) {
        case LEFT: {
            if ( col == 0 ) {
                return false;
            }
            ComponentModel* leftComp = grid[row][col-1];
            return [leftComp type] == SWITCH;
            break;
        }
        case RIGHT: {
            if ( col == numCols - 1 ) {
                return false;
            }
            ComponentModel* rightComp = grid[row][col+1];
            return [rightComp type] == SWITCH;
        }
        case TOP: {
            if ( row == 0 ) {
                return false;
            }
            ComponentModel* topComp = grid[row-1][col];
            return [topComp type] == SWITCH;
        }
        case BOTTOM: {
            if ( row == numRows - 1 ) {
                return false;
            }
            ComponentModel* bottomComp = grid[row+1][col];
            return [bottomComp type] == SWITCH;
        }
        default:
            return NO;
    }
}

/*
 * Get row, col, and possibly state information about a certain array of components
 * Input: The components to get the location and state information about and a boolean specifying if we need the state information
 * Ouput: An Array that contains the row, col, and possibly the state information in the 0,1,2 indices
 */
- (NSArray*) getConnectedLocations:(NSArray*)components withState:(BOOL)needState
{
    NSMutableArray *compLocs = [[NSMutableArray alloc] init];
    NSMutableArray *compRows = [[NSMutableArray alloc] init];
    NSMutableArray *compCols = [[NSMutableArray alloc] init];
    
    [compLocs addObject:compRows];
    [compLocs addObject:compCols];
    
    // Add the state array if needed
    if (needState) {
        NSMutableArray* compStates = [[NSMutableArray alloc] init];
        [compLocs addObject:compStates];
    }
    
    for (ComponentModel* comp in components) {
        if (needState || [comp state]) {
            [compLocs[0] addObject:[NSNumber numberWithInt:[comp row]]];
            [compLocs[1] addObject:[NSNumber numberWithInt:[comp col]]];
        }
        if (needState) {
            [compLocs[2] addObject:[NSNumber numberWithBool:[comp state]]];
        }
    }
    
    return compLocs;
}


/*
 * A breadth first search from a specified start to a specified end component, with an initial starting direction.
 * Input: The starting and target component, the initial direction and a parameter for if we're checking for a short
 * Output: A boolean, true if the search was succesful
 */
-(BOOL) breadthSearchFrom:(ComponentModel*)startComp To:(ComponentModel*)targetComp inDirection:(enum DIRECTION)direction CheckingForShort:(BOOL)checkForShort
{
    // Keep track of which locations we've already visited
    NSMutableArray* visited = [[NSMutableArray alloc] initWithCapacity:numRows];
    
    for (int i = 0; i < numRows; ++i) {
        NSMutableArray *visColumn = [[NSMutableArray alloc] initWithCapacity:numCols];
        [visited addObject:visColumn];
        for (int j = 0; j < numCols; ++j) {
            [visited[i] addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    // set up our queue
    NSMutableArray* connectionQueue = [[NSMutableArray alloc] init];
    
    // Add the first element given the direction of travel from light bulb

    ComponentModel* firstObject;
    switch (direction) {
        case LEFT:
            firstObject = grid[[startComp row]][[startComp col] - 1];
            break;
        case RIGHT:
            firstObject = grid[[startComp row]][[startComp col] + 1];
            break;
        case TOP:
            firstObject = grid[[startComp row] - 1][[startComp col]];
            break;
        case BOTTOM:
            firstObject = grid[[startComp row] + 1][[startComp col]];
            break;
        default:
            [NSException raise:@"Invalid direction input" format:@"Direction input is invalid"];
            break;
    }
    
    [connectionQueue addObject:firstObject];
    [[visited objectAtIndex:[startComp row]] setObject:[NSNumber numberWithInt:1] atIndex:[startComp col]];
    
    // search for target
    while ([connectionQueue count] > 0) {
        
        ComponentModel* element = connectionQueue[0];
        int row = [element row];
        int col = [element col];
        
        [connectionQueue removeObjectAtIndex:0];
        [[visited objectAtIndex:row] setObject:[NSNumber numberWithInt:1] atIndex:col];
        
        if ([element type] == [targetComp type] && [element row] == [targetComp row] && [element col] == [targetComp col]) {
            return YES;
        }
        
        // Ignore a path with a lightbulb, emitter or bomb in the short case
        if (checkForShort) {
            if ([element type] == BULB || [element type] == EMITTER || [element type] == BOMB) {
                continue;
            }
        }
        
        // Visit the 4 neighbors
        if ([element connectedLeft] && ![visited[row][col - 1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:grid[row][col-1]];
        }
        if ([element connectedRight] && ![visited[row][col + 1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:grid[row][col+1]];
        }
        if ([element connectedTop] && ![visited[row - 1][col] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:grid[row-1][col]];
        }
        if ([element connectedBottom] && ![visited[row + 1][col] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:grid[row+1][col]];
        }
    }
    
    return NO;
}

@end
