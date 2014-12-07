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

@interface GameModel()
{
    NSMutableArray* _grid;
    NSMutableArray* _bulbs;
    NSMutableArray* _bombs;
    
    int _numRows;
    int _numCols;
    BatteryModel* _batteryPos;
    BatteryModel* _batteryNeg;

    int _numLevels; // total number of levels
}

@end

@implementation GameModel


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
        
        _numRows = 15;
        _numCols = 15;

        _bulbs = [[NSMutableArray alloc] init];
        _bombs = [[NSMutableArray alloc] init];

        _grid = [[NSMutableArray alloc] init];
        
        _laserModel = [[LaserModel alloc] initWithGrid:_grid numRow:_numRows numCol:_numCols];
        // in each row spot add another array for the columns in the grid
        for (int r = 0; r < _numRows; ++r) {
            NSMutableArray *column = [[NSMutableArray alloc] init];
            [_grid addObject:column];
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
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"level%d",level] ofType:@""];
    NSError* error;
    NSString* data = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    // set the grid and component arrays
    [self setComponentsWithData:data];
    [self setConnectionsWithData:data];
}


/*
 * Cleares the grid of everything and clears the component arrays
 * Input: N/A
 * Output: N/A
 */
-(void) clearGridAndComponents
{
    // grid clearing
    for (int x = 0; x < _grid.count; ++x) {
        [_grid[x] removeAllObjects];
    }
    
    // component array clearing
    [_bulbs removeAllObjects];
    [_bombs removeAllObjects];
    [_laserModel clearLaserComponents];
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
    for (int r = 0; r < _numRows; ++r) {
        
        NSRange range = NSMakeRange(2*r*(2*_numCols+1), 2*_numCols-1); // the range for a row worth of data
        NSString *rowData = [data substringWithRange:range];

        for (int c = 0; c < _numCols; ++c) {

            int datum = [[rowData substringWithRange:NSMakeRange(2*c, 1)] intValue]; // The component enum type for one grid location
            
            // set the types as appropriate
            switch (datum) {
                case WIRE: {
                    WireModel *component = [[WireModel alloc] initAtRow:r AndCol:c WithState:NO];
                    [[_grid objectAtIndex:r] addObject:component];
                    break;
                }
                case EMITTER: {
                    EmitterModel *component = [[EmitterModel alloc] initAtRow:r AndCol:c WithState:NO];
                    [[_grid objectAtIndex:r] addObject:component];
                    [_laserModel addComponent:component];
                    break;
                }
                case BATTERY_NEG: {
                    BatteryModel *component = [[BatteryModel alloc] initAtRow:r AndCol:c WithState:NO Positive:NO];
                    _batteryNeg = component;
                    [[_grid objectAtIndex:r] addObject:component];
                    break;
                }
                case BATTERY_POS: {
                    BatteryModel *component = [[BatteryModel alloc] initAtRow:r AndCol:c WithState:NO Positive:YES];
                    _batteryPos = component;
                    [[_grid objectAtIndex:r] addObject:component];
                    break;
                }
                case BULB: {
                    BulbModel *component = [[BulbModel alloc] initAtRow:r AndCol:c WithState:NO];
                    [[_grid objectAtIndex:r] addObject:component];
                    break;
                }
                case RECEIVER: {
                    ReceiverModel *component = [[ReceiverModel alloc] initAtRow:r AndCol:c WithState:NO];
                    [[_grid objectAtIndex:r] addObject:component];
                    [_laserModel addComponent:component];
                    break;
                }
                case DEFLECTOR: {
                    DeflectorModel *component = [[DeflectorModel alloc] initAtRow:r AndCol:c WithState:NO];
                    [[_grid objectAtIndex:r] addObject:component];
                    [_laserModel addComponent:component];
                    break;
                }
                case SWITCH: {
                    SwitchModel *component = [[SwitchModel alloc] initAtRow:r AndCol:c WithState:NO];
//                    [component connectedRight:YES];
//                    [component connectedTop:YES];
                    [[_grid objectAtIndex:r] addObject:component];
                    break;
                }
                case BOMB: {
                    BombModel *component = [[BombModel alloc] initAtRow:r AndCol:c WithState:NO];
                    [_bombs addObject:component];
                    [[_grid objectAtIndex:r] addObject:component];
                    break;
                }
                default: {
                    ComponentModel* component = [[ComponentModel alloc] initAtRow:r AndCol:c WithState:NO];
                    [[_grid objectAtIndex:r] addObject:component];
                    break;
                }
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
    for (int r = 0; r < 2*_numRows-2; ++r) {
        
        NSRange range = NSMakeRange(r*(2*_numCols+1), 2*_numCols-1); // range for a rows worth of data
        NSString* rowData = [data substringWithRange:range];

        for (int c = 0; c < 2*_numCols-2; ++c) {
            
            NSString* datum = [rowData substringWithRange:NSMakeRange(c, 1)]; // One conenction type

            // Set the connections as appropriate
            if ([datum isEqual:@"-"]) {
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] setConnectedRight:YES];
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] setConnectedLeft:YES];
            } else if ([datum isEqual:@"|"]) {
                [[[_grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] setConnectedBottom:YES];
                [[[_grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] setConnectedTop:YES];
            } else if ([datum isEqual:@"+"]) {
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] setDirection:RIGHT];
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] setDirection:LEFT];
            } else if ([datum isEqual:@"*"]) {
                [[[_grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] setDirection:BOTTOM];
                [[[_grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] setDirection:TOP];
            }
        }
    }
}


# pragma mark Public Methods


/*
 * Get the number of rows in the model
 * Input: N/A
 * Output: The number of rows
 */
- (int) getNumRows
{
    return _numRows;
}


/*
 * Get the number of cols in the model
 * Input: N/A
 * Output: The number of cols
 */
- (int) getNumCols
{
    return _numCols;
}


/*
 * Gets the type of component at a specified location including its connection suffix
 * Input: Row and Col information
 * Output: The component type
 */
-(NSString*) getTypeAtRow:(int)row andCol:(int)col
{
    // Input validation
    NSAssert((row <= _numRows) && (row >= 0), @"Invalid row argument");
    NSAssert((col >= 0) && (col <= _numCols), @"Invalid col argument");
    
    ComponentModel* component = [[_grid objectAtIndex:row] objectAtIndex:col];
    NSString* compWithConn = [self getComponentWithConnectionsFor:component];
    
    return compWithConn;
}


/*
 * Adjust the model to a component being selected, specifically adjust the connections for the component and the components surrounding it
 * Input: The position of the component and its new orientation
 * Output: N/A
 */
-(void) componentSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation
{
    // Input validation
    NSRegularExpression *orientationForm = [[NSRegularExpression alloc] initWithPattern:@"[LX][RX][TX][BX]" options:0 error:nil];
    NSUInteger numMatchesToForm = [orientationForm numberOfMatchesInString:newOrientation options:0 range:NSMakeRange(0, 4)];
    NSAssert(numMatchesToForm == 1, @"Invalid orientation argument");
    
    NSAssert((row <= _numRows) && (row >= 0), @"Invalid row argument");
    NSAssert((col >= 0) && (col <= _numCols), @"Invalid col argument");
    
    ComponentModel* component = _grid[row][col];
    // Adjust the connections in all 4 directions, keeping in mind the edge components
    if ( col != 0 ) {
        if ([[newOrientation substringWithRange:NSMakeRange(0, 1)] isEqual:@"L"]) {
            [component setConnectedLeft:YES];
            [_grid[row][col - 1] setConnectedRight:YES];
        } else {
            [component setConnectedLeft:NO];
            [_grid[row][col - 1] setConnectedRight:NO];
        }
    }
    
    if ( col != _numCols-1 ) {
        if ([[newOrientation substringWithRange:NSMakeRange(1, 1)] isEqual:@"R"]) {
            [component setConnectedRight:YES];
            [_grid[row][col + 1] setConnectedLeft:YES];
        } else {
            [component setConnectedRight:NO];
            [_grid[row][col + 1] setConnectedLeft:NO];
        }
    }
    
    if (row != 0) {
        if ([[newOrientation substringWithRange:NSMakeRange(2, 1)] isEqual:@"T"]) {
            [component setConnectedTop:YES];
            [_grid[row - 1][col] setConnectedBottom:YES];
        } else {
            [component setConnectedTop:NO];
            [_grid[row - 1][col] setConnectedBottom:NO];
        }
    }
    
    if (row != _numRows - 1) {
        if ([[newOrientation substringWithRange:NSMakeRange(3, 1)] isEqual:@"B"]) {
            [component setConnectedBottom:YES];
            [_grid[row + 1][col] setConnectedTop:YES];
        } else {
            [component setConnectedBottom:NO];
            [_grid[row + 1][col] setConnectedTop:NO];
        }
    }
}


/*
 * Gets a list of all emitters with the information about their connected state
 * Input: N/A
 * Output: An array of emitters
 */
-(NSArray*) getConnectedEmitters
{
    return [self getConnectedLocations:[_laserModel getEmitters] withState:YES];
}


/*
 * Gets a list of all deflectors with the information about their connected state
 * Input: N/A
 * Output: An array of deflectors
 */
-(NSArray*) getConnectedDeflectors
{
    return [self getConnectedLocations:[_laserModel getDeflectors] withState:YES];
}

/*
 * Gets a list of all receivers with the information about their connected state
 * Input: N/A
 * Output: An array of receivers
 */
-(NSArray*) getConnectedReceivers
{
    return [self getConnectedLocations:[_laserModel getReceivers] withState:YES];
}


/*
 * Gets a list of all bulbs with the information about their connected state
 * Input: N/A
 * Output: An array of bulbs
 */
- (NSArray*) getConnectedBulbs
{
    return [self getConnectedLocations:_bulbs withState:YES];
}


/*
 * Gets a list of bombs that should be detonated
 * Input: N/A
 * Output: An array of bombs
 */
- (NSArray*) getConnectedBombs
{
    return [self getConnectedLocations:_bombs withState:NO];
}


/*
 * Gets a list of lasers that should be present on the grid
 * Input: N/A
 * Output: An array of lasers
 */
-(NSArray*) getLasers
{
    return [self getConnectedLocations:[_laserModel getLasers] withState:NO];
}


/*
 * Checks to see if the grid is fully connected
 * Input: N/A
 * Output: A boolean, true if the grid is fully connected
 */
-(BOOL) isConnected
{
    NSArray* connectedBulbLoc = [self getConnectedLocations:_bulbs withState:NO];
    NSArray* connectedBulbs = connectedBulbLoc[0];
    
    if (connectedBulbs.count == _bulbs.count) {
        return true;
    } else {
        return false;
    }
}


/*
 * Checks to see if there is a short in the grid
 * Input: N/A
 * Output: A boolean, true if the grid is shorted
 */
-(BOOL) isShorted
{
    return [self breadthSearchFrom:_batteryNeg To:_batteryPos inDirection:@"Right" CheckingForShort:true];
}


/*
 * Checks to see if any bombs are connected
 * Input: N/A
 * Output: A boolean, true if atleast one bomb is connected
 */
-(BOOL) isBombConnected
{
    NSArray* connectedBombLoc = [self getConnectedBombs];
    NSArray* connectedBombs = connectedBombLoc[0];
    return (connectedBombs.count > 0);
}


/*
 * When the circuit is powered on, we update the states of all the components
 * Input: N/A
 * Output: N/A
 */
- (void) powerOn
{
    [_batteryPos setState:YES];
    [_batteryNeg setState:YES];
    
    [self resetComponents];
    
    [self updateStateOfComponents:[_laserModel getEmitters]];
    
    // With the laser components theres a possibility that certain updates can induce changes in more components
    // Therefore we loop until there are no more differences.
    while (true) {
        //[self updateLasers];
        [_laserModel updateLasers];
        
        [self updateStateOfComponents:_bulbs];
        [self updateStateOfComponents:_bombs];
        
        NSArray* emitterStates = [self stateOf:[_laserModel getEmitters]];
        [self updateStateOfComponents:[_laserModel getEmitters]];
        if (![_laserModel didEmitterStateChange:emitterStates]) {
            break;
        }
    }
}


/*
 * When the circuit is powered off we reset the components
 * Input: N/A
 * Output: N/A
 */
- (void) powerOff
{
    [_batteryPos setState:NO];
    [_batteryNeg setState:NO];
    [self resetComponents];
}


# pragma mark Helper Methods


/*
 * Gets the type of component with its connection suffix
 * Input: The component
 * Output: The component type
 */
- (NSString*) getComponentWithConnectionsFor:(ComponentModel*)component
{
    NSString* type = [component getType];
    
    // get the conenction suffix
    NSString* connections;
    connections = [self getConnectionsFor:component];

    // Based on component type either append or don't append the connections
    NSString* compWithConn;
    if ( [type isEqual:@"wire"] || [type isEqual:@"batteryNeg"] || [type isEqual:@"batteryPos"] || [type isEqual:@"emitter"] || [type isEqual:@"receiver"] || [type isEqual:@"bomb"] || [type isEqual:@"laser"] ) {
        compWithConn = [type stringByAppendingString:connections];
    } else {
        compWithConn = type;
    }
    
    return compWithConn;
}


/*
 * Gets the connections for a specificed component
 * Input: The component
 * Ouput: The connection string used as the file name suffix
 */
-(NSString*) getConnectionsFor:(ComponentModel*)component
{
    NSString* type = [component getType];
    
    NSString* connections = [[NSString alloc] init];
    // If it's a laser type component we need to add direction information
    if([type isEqual:@"emitter"] || [type isEqual:@"receiver"]){
        connections = [connections stringByAppendingString:[component getDirection]];
    }
    
    // Check all 4 directions for conenctions
    if ( [component isConnectedLeft] || [self hasSwitchTo:@"Left" OfComponent:component]) {
        connections = [connections stringByAppendingString:@"L"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }

    if ( [component isConnectedRight] || [self hasSwitchTo:@"Right" OfComponent:component]) {
        connections = [connections stringByAppendingString:@"R"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }

    if ( [component isConnectedTop] || [self hasSwitchTo:@"Top" OfComponent:component]) {
        connections = [connections stringByAppendingString:@"T"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }

    if ( [component isConnectedBottom] || [self hasSwitchTo:@"Bottom" OfComponent:component]) {
        connections = [connections stringByAppendingString:@"B"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    return connections;
}


/*
 * Tells you a component has a switch to a specified direction of a specified component
 * Input: The component and direction to look
 * Output: Boolean for whether the component has a switch to that direction
 */
- (BOOL) hasSwitchTo:(NSString*)direction OfComponent:(ComponentModel*)component
{
    int row = [component getRow];
    int col = [component getCol];

    // A case for each direction. For each direction check for bound case.
    if ( [direction isEqual:@"Left"] ) {
        if ( col == 0 ) {
            return false;
        }
        
        ComponentModel* leftComp = _grid[row][col-1];
        return [[leftComp getType] isEqual:@"switch"];

    } else if ( [direction isEqual:@"Right"] ) {
        if ( col == _numCols - 1 ) {
            return false;
        }
        
        ComponentModel* rightComp = _grid[row][col+1];
        return [[rightComp getType] isEqual:@"switch"];

    } else if ( [direction isEqual:@"Top"] ) {
        if ( row == 0 ) {
            return false;
        }
        ComponentModel* topComp = _grid[row-1][col];
        return [[topComp getType] isEqual:@"switch"];

    } else if ( [direction isEqual:@"Bottom"] ) {
        if ( row == _numRows - 1 ) {
            return false;
        }
        
        ComponentModel* bottomComp = _grid[row+1][col];
        return [[bottomComp getType] isEqual:@"switch"];

    } else {
        // Invalid direction input, throw exception
        [NSException raise:@"Invalid direction input" format:@"Direction Input:%@ is invalid", direction];
        return false;
    }
}


/*
 * Get row, col, and possibly state information about a certain array of components
 * Input: The components to get the location and state information about and a boolean specifying if we need the state information
 * Ouput: An Array that contains the row, col, and possibly the state information in the 0,1,2 indices
 */
- (NSArray*) getConnectedLocations:(NSArray*)components withState:(BOOL)needState
{
    NSMutableArray* compLocs = [[NSMutableArray alloc] init];
    NSMutableArray* compRows = [[NSMutableArray alloc] init];
    NSMutableArray* compCols = [[NSMutableArray alloc] init];
    
    [compLocs addObject:compRows];
    [compLocs addObject:compCols];
    
    // Add the state array if needed
    if (needState) {
        NSMutableArray* compStates = [[NSMutableArray alloc] init];
        [compLocs addObject:compStates];
    }
    
    for (ComponentModel* comp in components) {
        if (needState || [comp getState]) {
            [compLocs[0] addObject:[NSNumber numberWithInt:[comp getRow]]];
            [compLocs[1] addObject:[NSNumber numberWithInt:[comp getCol]]];
        }
        if (needState) {
            [compLocs[2] addObject:[NSNumber numberWithBool:[comp getState]]];
        }
    }
    
    return compLocs;
}


/*
 * A breadth first search from a specified start to a specified end component, with an initial starting direction.
 * Input: The starting and target component, the initial direction and a parameter for if we're checking for a short
 * Output: A boolean, true if the search was succesful
 */
-(BOOL) breadthSearchFrom:(ComponentModel*)startComp To:(ComponentModel*)targetComp inDirection:(NSString*)direction CheckingForShort:(BOOL)checkForShort
{
    // Keep track of which locations we've already visited
    NSMutableArray* visited = [[NSMutableArray alloc] initWithCapacity:_numRows];
    
    for (int i = 0; i < _numRows; ++i) {
        NSMutableArray *visColumn = [[NSMutableArray alloc] initWithCapacity:_numCols];
        [visited addObject:visColumn];
        for (int j = 0; j < _numCols; ++j) {
            [visited[i] addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    // set up our queue
    NSMutableArray* connectionQueue = [[NSMutableArray alloc] init];
    
    // Add the first element given the direction of travel from light bulb
    ComponentModel* firstObject;
    if ([direction isEqual:@"Left"]) {
        firstObject = _grid[[startComp getRow]][[startComp getCol] - 1];
    } else if ([direction isEqual:@"Right"]) {
        firstObject = _grid[[startComp getRow]][[startComp getCol] + 1];
    } else if ([direction isEqual:@"Top"]) {
        firstObject = _grid[[startComp getRow] - 1][[startComp getCol]];
    } else if ([direction isEqual:@"Bottom"]) {
        firstObject = _grid[[startComp getRow] + 1][[startComp getCol]];
    } else {
        // Invalid direction input, throw exception
        [NSException raise:@"Invalid direction input" format:@"Direction input:%@ is invalid", direction];
    }
    [connectionQueue addObject:firstObject];
    [[visited objectAtIndex:[startComp getRow]] setObject:[NSNumber numberWithInt:1] atIndex:[startComp getCol]];
    
    // search for target
    while ([connectionQueue count] > 0) {
        
        ComponentModel* element = connectionQueue[0];
        int row = [element getRow];
        int col = [element getCol];
        
        [connectionQueue removeObjectAtIndex:0];
        [[visited objectAtIndex:row] setObject:[NSNumber numberWithInt:1] atIndex:col];
        
        if ([element isSameComponentAs:targetComp]) {
            return YES;
        }
        
        // Ignore a path with a lightbulb, emitter or bomb in the short case
        if (checkForShort) {
            if ([[element getType] isEqual:@"bulb"] || [[element getType] isEqual:@"emitter"] || [[element getType] isEqual:@"bomb"]) {
                continue;
            }
        }
        
        // Visit the 4 neighbors
        if ([element isConnectedLeft] && ![visited[row][col - 1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row][col-1]];
        }
        if ([element isConnectedRight] && ![visited[row][col + 1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row][col+1]];
        }
        if ([element isConnectedTop] && ![visited[row - 1][col] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row-1][col]];
        }
        if ([element isConnectedBottom] && ![visited[row + 1][col] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row+1][col]];
        }
    }
    
    return NO;
}


/*
 * Reset all the changing components
 * Input: N/A
 * Output: N/A
 */
- (void) resetComponents
{
    [self reset:_bulbs];
    [self reset:_bombs];
    //reset the emitters and lasers
    [_laserModel resetComponents];
    [_laserModel clearLasers];
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

- (void) updateStateOfComponents:(NSArray*)components
{
    for (ComponentModel* comp in components) {
        
        // Make sure the component is valid
        NSArray* connections = [self getAllConnectionsTo:comp];
        if (connections.count < 2) {
            if (![[comp getType] isEqual:@"bomb"]){
                [comp setState:NO];
            }
            continue;
        }
        
        // Check if the component is connected by battery following the two possible paths
        BOOL path1Pos = [self breadthSearchFrom:comp To:_batteryPos inDirection:connections[0] CheckingForShort:NO];
        BOOL path1Neg = [self breadthSearchFrom:comp To:_batteryNeg inDirection:connections[1] CheckingForShort:NO];
        BOOL path2Neg = [self breadthSearchFrom:comp To:_batteryNeg inDirection:connections[0] CheckingForShort:NO];
        BOOL path2Pos = [self breadthSearchFrom:comp To:_batteryPos inDirection:connections[1] CheckingForShort:NO];
        
        // If one of paths is there, set the state to on
        if ((path1Pos && path1Neg) || (path2Pos && path2Neg)) {
            [comp setState:YES];
            continue;
        }
        
        // Now check if the component is connected by a receiver that is on
        if (![[comp getType] isEqual:@"receiver"]) {
            NSArray* receivers = [_laserModel getReceivers];
            for (int j = 0; j < receivers.count; ++j){
                    
                BOOL path1 = [self breadthSearchFrom:comp To:receivers[j] inDirection:connections[0] CheckingForShort:NO];
                BOOL path2 = [self breadthSearchFrom:comp To:receivers[j] inDirection:connections[1] CheckingForShort:NO];
                
                if (path1 && path2 && [receivers[j] getState]) {
                    [comp setState:YES];
                    break;
                } else {
                    [comp setState:NO];
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

    if ( [component isConnectedLeft] ) {
        [connections addObject:@"Left"];
    }
    if ( [component isConnectedRight] ) {
        [connections addObject:@"Right"];
    }
    if ( [component isConnectedTop] ) {
        [connections addObject:@"Top"];
    }
    if ( [component isConnectedBottom] ) {
        [connections addObject:@"Bottom"];
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
    NSMutableArray* states = [[NSMutableArray alloc] init];
    for (ComponentModel* comp in components) {
        [states addObject:[NSNumber numberWithBool:[comp getState]]];
    }
    
    return states;
}

/**
-(void) printGrid
{
    for(int r = 0;r<29;r++)
    {
        printf("{");
        for(int c=0;c<29;c++)
        {
            printf([_grid[r][c] UTF8String]);
        }
        printf("},\n");
    }
}**/


@end
