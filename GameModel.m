//
//  GameModel.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "GameModel.h"
#import "ComponentModel.h"

@interface GameModel()
{
    NSMutableArray* _grid;
    NSMutableArray* _bulbs;
    NSMutableArray* _bombs;

    //laser component arrays
    NSMutableArray* _lasers;
    NSMutableArray* _emitters;
    NSMutableArray* _deflectors;
    NSMutableArray* _receivers;

    int _numRows;
    int _numCols;
    ComponentModel* _batteryPos;
    ComponentModel* _batteryNeg;

    int _numLevels; // total number of levels
}

@end

@implementation GameModel

-(id) initWithTotalLevels:(int)totalLevels
{
    _numLevels = totalLevels;
    
    if (self = [super init]) {
        
        _numRows = 15;
        _numCols = 15;
        
        // initialize arrays
        _grid = [[NSMutableArray alloc] init];
        _bulbs = [[NSMutableArray alloc] init];
        _bombs = [[NSMutableArray alloc] init];
        _lasers = [[NSMutableArray alloc] init];
        _emitters = [[NSMutableArray alloc] init];
        _deflectors = [[NSMutableArray alloc] init];
        _receivers = [[NSMutableArray alloc] init];
        
        // in each row spot add another array for the columns in the grid
        for (int r = 0; r < _numRows; ++r) {
            NSMutableArray *column = [[NSMutableArray alloc] init];
            [_grid addObject:column];
        }
    }
    
    return self;
}

// assumptions: level is in [-4, numLevels]
-(void) generateGrid: (int) level
{
    [self clearGridAndComponents];
    
    // Make sure that the input for this method is valid
    NSAssert((level <= _numLevels), @"Invalid level argument");
    NSAssert((level >= -4), @"Invalid level argument"); // <--Adjust this when testing to allow for test grids.
    
    // get the txt file with the grid data
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"level%d",level] ofType:@""];
    NSError* error;

    NSString* data = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [self setComponentsWithData:data];
    [self setConnectionsWithData:data];
    
    //For debug
    //[self printGrid];
}

// Used in generateGrid
-(void) clearGridAndComponents
{
    for (int x = 0; x < _grid.count; ++x) {
        [_grid[x] removeAllObjects];
    }

    _lasers = [[NSMutableArray alloc] init];
    _emitters = [[NSMutableArray alloc] init];
    _deflectors = [[NSMutableArray alloc] init];
    _receivers = [[NSMutableArray alloc] init];
    
    [_bulbs removeAllObjects];
    [_bombs removeAllObjects];
}

// Used in generateGrid
- (void) setComponentsWithData:(NSString*)data
{
    // Set all the components on the grid
    for (int r = 0; r < _numRows; ++r) {
        NSRange range = NSMakeRange(2*r*(2*_numCols+1), 2*_numCols-1); // the range for a row worth of data
        NSString* rowData = [data substringWithRange:range];

        for (int c = 0; c < _numCols; ++c) {

            NSString* datum = [rowData substringWithRange:NSMakeRange(2*c, 1)];
            ComponentModel* component;
            if ([datum isEqual:@"1"]) {
                component = [[ComponentModel alloc] initOfType:@"Wire" AtRow:r AndCol:c AndState:NO];
            } else if ([datum isEqual:@"3"]) {
                component = [[ComponentModel alloc] initOfType:@"BatteryNeg" AtRow:r AndCol:c AndState:NO];
                _batteryNeg = component;
            } else if ([datum isEqual:@"4"]) {
                component = [[ComponentModel alloc] initOfType:@"Bulb" AtRow:r AndCol:c AndState:NO];
                [_bulbs addObject:component];
            } else if ([datum isEqual:@"6"]) {
                component = [[ComponentModel alloc] initOfType:@"BatteryPos" AtRow:r AndCol:c AndState:NO];
                _batteryPos = component;
            } else if ([datum isEqual:@"7"]) {
                component = [[ComponentModel alloc] initOfType:@"Switch" AtRow:r AndCol:c AndState:NO];
            } else if ([datum isEqual:@"2"]) { //code for laser components
                component = [[ComponentModel alloc] initOfType:@"Emitter" AtRow:r AndCol:c AndState:NO];
                [_emitters addObject:component];
            } else if ([datum isEqual:@"5"]) {
                component = [[ComponentModel alloc] initOfType:@"Receiver" AtRow:r AndCol:c AndState:NO];
                [_receivers addObject:component];
            } else if ([datum isEqual:@"8"]) {
                component = [[ComponentModel alloc] initOfType:@"Deflector" AtRow:r AndCol:c AndState:NO];
                [_deflectors addObject:component];
            } else if ([datum isEqual:@"9"]) {
                component = [[ComponentModel  alloc] initOfType:@"Bomb" AtRow:r AndCol:c AndState:NO];
                [_bombs addObject:component];
            } else {
                component = [[ComponentModel alloc] initOfType:@"Empty" AtRow:r AndCol:c AndState:NO];
            }

            [[_grid objectAtIndex:r] addObject:component];
        }
    }
}

// Used in generateGrid
- (void) setConnectionsWithData:(NSString*)data
{
    // Find the connections and update the components accordingly
    for (int r = 0; r < 2*_numRows-2; ++r) {
        NSRange range = NSMakeRange(r*(2*_numCols+1), 2*_numCols-1);
        NSString* rowData = [data substringWithRange:range];

        for (int c = 0; c < 2*_numCols-2; ++c) {
            NSString* datum = [rowData substringWithRange:NSMakeRange(c, 1)];

            // Set the connections as appropriate
            if ([datum isEqual:@"-"]) {
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] connectedRight:true];
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] connectedLeft:true];
            } else if ([datum isEqual:@"|"]) {
                [[[_grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] connectedBottom:true];
                [[[_grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] connectedTop:true];
            } else if ([datum isEqual:@"7"]) {
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] connectedRight:false];
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] connectedLeft:false];
                [[[_grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] connectedBottom:false];
                [[[_grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] connectedTop:false];
            } else if ([datum isEqual:@"+"]) {
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] pointTo:@"Right"];
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] pointTo:@"Left"];
            } else if ([datum isEqual:@"*"]) {
                [[[_grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] pointTo:@"Bottom"];
                [[[_grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] pointTo:@"Top"];
            }
        }
    }
}

// assumption: row is in [0, _numRows]; col is in [0, _numCols]
-(NSString*) getTypeAtRow:(int)row andCol:(int)col
{
    NSAssert((row <= _numRows) && (row >= 0), @"Invalid row argument"); // Make sure row input is valid
    NSAssert((col >= 0) && (col <= _numCols), @"Invalid col argument"); // Make sure col input is valid
    
    ComponentModel* component = [[_grid objectAtIndex:row] objectAtIndex:col];

    // find the connections the component has
    NSString* compWithConn = [self getComponentWithConnectionsFor:component];
    
    return compWithConn;
}

// determine the component and what connections it has based on the type and the location
// components table:
// 0: blank
// 1: wire
// 2: emitter
// 3: negative battery
// 4: bulb
// 5: receiver
// 6: positive battery
// 7: switch
// 8: deflector
// 9: bomb

- (NSString*) getComponentWithConnectionsFor:(ComponentModel*)component
{
    
    NSString* connections;
    
    // get the component type
    NSString* type = [component getType];

    connections = [self getConnectionsFor:component];

    NSString* compWithConn;

    if ( [type isEqual:@"Wire"] ) {
        compWithConn = [@"wire" stringByAppendingString:connections];
    } else if ( [type isEqual:@"BatteryNeg"] ) {
        compWithConn = [@"batteryNeg" stringByAppendingString:connections];
    } else if ( [type isEqual:@"BatteryPos"] ) {
        compWithConn = [@"batteryPos" stringByAppendingString:connections];
    } else if ( [type isEqual:@"Bulb"] ) {
        compWithConn = @"bulb";
    } else if ( [type isEqual:@"Switch"] ) {
        compWithConn = @"switch";
    } else if ( [type isEqual:@"Emitter"] ) {
        compWithConn = [@"emitter" stringByAppendingString:connections];
    } else if ( [type isEqual:@"Receiver"] ) {
        compWithConn = [@"receiver" stringByAppendingString:connections];
    } else if ( [type isEqual:@"Deflector"] ) {
        compWithConn = @"deflector";
    } else if ( [type isEqual:@"Bomb"] ) {
        compWithConn = [@"bomb" stringByAppendingString:connections];
    } else if ( [type isEqual:@"Laser"] ) {
        compWithConn = [@"laser" stringByAppendingString:connections];
    } else {

        compWithConn = @"empty";
    }
    
    return compWithConn;
}

// These connections are for imagename generation so we include the possibility of being connected to a switch
-(NSString*) getConnectionsFor:(ComponentModel*)component
{
    
    NSString* connections = @"";
    
    // get type, slightly different connection suffix for lasers
    NSString* type = [component getType];
    
    //Check for laser connections
    if([type isEqual:@"Emitter"] || [type isEqual:@"Receiver"]){
        
        NSString* laserDir = [component getDirection];
        
        if ([laserDir isEqual:@"Top"]){
            connections = [connections stringByAppendingString:@"Top"];
        } else if([laserDir isEqual:@"Bottom"]){
            connections = [connections stringByAppendingString:@"Bottom"];
        } else if([laserDir isEqual:@"Left"]){
            connections = [connections stringByAppendingString:@"Left"];
        } else if([laserDir isEqual:@"Right"]){
            connections = [connections stringByAppendingString:@"Right"];
        } else {
            [NSException raise:@"Invalid laser direction" format:@"Laser direction:%@ is invalid", laserDir];
        }
    }

    // Check for connections in all 4 directions
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

- (BOOL) hasSwitchTo:(NSString*)direction OfComponent:(ComponentModel*)component
{
    int row = [component getRow];
    int col = [component getCol];

    if ( [direction isEqual:@"Left"] ) {

        if ( col == 0 ) {
            return false;
        }
        ComponentModel* leftComp = _grid[row][col-1];
        return [[leftComp getType] isEqual:@"Switch"];

    } else if ( [direction isEqual:@"Right"] ) {

        if ( col == _numCols - 1 ) {
            return false;
        }
        ComponentModel* rightComp = _grid[row][col+1];
        return [[rightComp getType] isEqual:@"Switch"];

    } else if ( [direction isEqual:@"Top"] ) {

        if ( row == 0 ) {
            return false;
        }
        ComponentModel* topComp = _grid[row-1][col];
        return [[topComp getType] isEqual:@"Switch"];

    } else if ( [direction isEqual:@"Bottom"] ) {

        if ( row == _numRows - 1 ) {
            return false;
        }
        ComponentModel* bottomComp = _grid[row+1][col];
        return [[bottomComp getType] isEqual:@"Switch"];

    } else {
        // Invalid direction input, throw exception
        [NSException raise:@"Invalid direction input" format:@"Direction Input:%@ is invalid", direction];
        return false;
    }

}

// Update the grid with the connection of the switch
-(void) componentSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation
{
    // Make sure orientation input is valid
    NSRegularExpression *orientationForm = [[NSRegularExpression alloc] initWithPattern:@"[LX][RX][TX][BX]" options:0 error:nil];
    NSUInteger numMatchesToForm = [orientationForm numberOfMatchesInString:newOrientation options:0 range:NSMakeRange(0, 4)];
    NSAssert(numMatchesToForm == 1, @"Invalid orientation argument");
    
    // Make sure row and col input is valid
    NSAssert((row <= _numRows) && (row >= 0), @"Invalid row argument");
    NSAssert((col >= 0) && (col <= _numCols), @"Invalid col argument");

    // Get the component
    ComponentModel* component = _grid[row][col];

    // Make sure that row and col describe switch location
    NSAssert([[component getType] isEqual:@"Switch"]||[[component getType] isEqual:@"Deflector"], @"Input location does not correspond to switch");
    
    // As long as location is not left most column, adjust left cell
    if ( col != 0 ) {
        if ([[newOrientation substringWithRange:NSMakeRange(0, 1)] isEqual:@"L"]) {
            [component connectedLeft:YES];
            [_grid[row][col - 1] connectedRight:YES];
        } else {
            [component connectedLeft:NO];
            [_grid[row][col - 1] connectedRight:NO];
        }
    }
    
    // As long as location is not right most column, adjust right cell
    if ( col != _numCols-1 ) {
        if ([[newOrientation substringWithRange:NSMakeRange(1, 1)] isEqual:@"R"]) {
            [component connectedRight:YES];
            [_grid[row][col + 1] connectedLeft:YES];
        } else {
            [component connectedRight:NO];
            [_grid[row][col + 1] connectedLeft:NO];
        }
    }
    
    // As long as location is not upper most row, adjust above cell
    if (row != 0) {
        if ([[newOrientation substringWithRange:NSMakeRange(2, 1)] isEqual:@"T"]) {
            [component connectedTop:YES];
            [_grid[row - 1][col] connectedBottom:YES];
        } else {
            [component connectedTop:NO];
            [_grid[row - 1][col] connectedBottom:NO];
        }
    }
    
    // As long as location is not lower most row, adjust below cell
    if (row != _numRows - 1) {
        if ([[newOrientation substringWithRange:NSMakeRange(3, 1)] isEqual:@"B"]) {
            [component connectedBottom:YES];
            [_grid[row + 1][col] connectedTop:YES];
        } else {
            [component connectedBottom:NO];
            [_grid[row + 1][col] connectedTop:NO];
        }
    }
}



-(NSArray*) getConnectedEmitters
{
    return [self getConnectedLocations:_emitters withState:YES];
}

-(NSArray*) getConnectedDeflectors
{
    return [self getConnectedLocations:_deflectors withState:YES];
}

-(NSArray*) getConnectedReceivers
{
    return [self getConnectedLocations:_receivers withState:YES];
}

-(NSArray*) getLasers
{
    return [self getConnectedLocations:_lasers withState:NO];
}

- (NSArray*) getConnectedBulbs
{
    return [self getConnectedLocations:_bulbs withState:YES];
}

- (NSArray*) getConnectedBombs
{
    NSArray* result = [self getConnectedLocations:_bombs withState:NO];
    return [self getConnectedLocations:_bombs withState:NO];
}

// When we want to get a location array to apss to gameviewcontroller
// Sometimes we only need the location, other times we also need the state
- (NSArray*) getConnectedLocations:(NSArray*)components withState:(BOOL)needState
{
    NSMutableArray* compLocs = [[NSMutableArray alloc] init];
    NSMutableArray* compRows = [[NSMutableArray alloc] init];
    NSMutableArray* compCols = [[NSMutableArray alloc] init];
    
    [compLocs addObject:compRows];
    [compLocs addObject:compCols];
    
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

- (void) resetLasers
{
    for (int i = 0; i < _lasers.count; ++i) {
        int laserRow = [_lasers[i] getRow];
        int laserCol = [_lasers[i] getCol];
        
        ComponentModel* component = [[ComponentModel alloc] initOfType:@"Empty" AtRow:laserRow AndCol:laserCol AndState:NO];
        _grid[laserRow][laserCol] = component;
    }
    
    [_lasers removeAllObjects];
}

- (void) updateLasers
{
    
    [self resetLasers];
    
    for(int i = 0; i<_deflectors.count; ++i){
        [_deflectors[i] setState:NO];
    }
    for(int i = 0; i<_receivers.count; ++i){
        [_receivers[i] setState:NO];
    }
    for(int i = 0; i<_emitters.count; ++i){
        [self createLaserPathFromComp:_emitters[i]];
    }
}

// create a laser beam path from an emitter
- (void) createLaserPathFromComp:(ComponentModel*)comp
{
    NSAssert([[comp getType] isEqual:@"Emitter"], @"Input location does not correspond to emitter");
    
    int emRow = [comp getRow];
    int emCol = [comp getCol];
    
    if([comp getState]){
        NSString* dir = [comp getDirection];
        
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
    // Draw a beam above the emitter until we reach an obstacle
    while ((row>0)&&([[_grid[row-1][col] getType] isEqual:@"Empty"])){
        ComponentModel* comp = [[ComponentModel alloc] initOfType:@"Laser" AtRow:row-1 AndCol:col AndState:@"On"];
        [comp connectedBottom:YES];
        [comp connectedTop:YES];
        
        _grid[row-1][col] = comp;
        [_lasers addObject:comp];
        --row;
    }

    if (row != 0) {
        --row;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Bottom"];
    }
}

- (void) laserBottomAtRow:(int)row Col:(int)col
{
    // Draw a beam below until we reach an obstacle
    while ((row<_numRows-1)&&([[_grid[row+1][col] getType] isEqual:@"Empty"])){
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"Laser" AtRow:row+1 AndCol:col AndState:@"On"];
        [comp connectedBottom:YES];
        [comp connectedTop:YES];
        
        _grid[row+1][col] = comp;
        [_lasers addObject:comp];
        ++row;
    }

    if (row != _numRows-1) {
        ++row;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Top"];
    }

}

- (void) laserLeftAtRow:(int)row Col:(int)col
{
    while ((col>0)&&([[_grid[row][col-1] getType] isEqual:@"Empty"])){
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"Laser" AtRow:row AndCol:col-1 AndState:@"On"];
        [comp connectedLeft:YES];
        [comp connectedRight:YES];
        
        _grid[row][col-1] = comp;
        [_lasers addObject:comp];
        --col;
    }
    
    if (col != 0) {
        --col;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Right"];
    }

}

- (void) laserRightAtRow:(int)row Col:(int)col
{
    while ((col<_numCols-1)&&([[_grid[row][col+1] getType] isEqual:@"Empty"])){
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"Laser" AtRow:row AndCol:col+1 AndState:@"On"];
        [comp connectedLeft:YES];
        [comp connectedRight:YES];
        
        _grid[row][col+1] = comp;
        [_lasers addObject:comp];
        ++col;
    }
    
    if (col != _numCols-1) {
        ++col;
        [self encounteredObstacleAtRow:row AndCol:col From:@"Left"];
    }
}

- (void) encounteredObstacleAtRow:(int)row AndCol:(int)col From:(NSString*)dir
{
    
    ComponentModel *obstacle = _grid[row][col];
    
    if ([[obstacle getType] isEqual:@"Deflector"]) { // Handle the obstacle being a deflector
        
        // First determine the state of the deflector
        if ([obstacle isConnectedBottom] && [dir isEqual:@"Bottom"]) {
            [obstacle setState:YES];
        } else if ([obstacle isConnectedTop] && [dir isEqual:@"Top"]) {
            [obstacle setState:YES];
        } else if ([obstacle isConnectedLeft] && [dir isEqual:@"Left"]) {
            [obstacle setState:YES];
        } else if ([obstacle isConnectedRight] && [dir isEqual:@"Right"]) {
            [obstacle setState:YES];
        } else {
            return; // The deflector doesn't point to the laser beam
        }
        
        // If the deflector was in an appropriate state we can continue the beam
        if ([obstacle isConnectedBottom] && ![dir isEqual:@"Bottom"]) {
            [self laserBottomAtRow:row Col:col];
        } else if ([obstacle isConnectedTop] && ![dir isEqual:@"Top"]) {
            [self laserTopAtRow:row Col:col];
        } else if ([obstacle isConnectedLeft] && ![dir isEqual:@"Left"]) {
            [self laserLeftAtRow:row Col:col];
        } else if ([obstacle isConnectedRight] && ![dir isEqual:@"Right"]) {
            [self laserRightAtRow:row Col:col];
        } else {
            return; // The deflector doesn't deflect anywhere
        }
    } else if ([[obstacle getType] isEqual:@"Receiver"]) { // Handle the obstacle being a reflector
        
        if ([[obstacle getDirection] isEqual:dir]) {
            [obstacle setState:YES];
        }
        
    } else if ([[obstacle getType] isEqual:@"Bomb"]) { // Handle the obstacle being a bomb
        
        [obstacle setState:YES];
    } else {
        return; // Some other type of obstacle
    }
    
}

-(BOOL) isShorted
{
    // check if two nodes of battery are connected directly
    return [self breadthSearchFrom:_batteryNeg To:_batteryPos inDirection:@"Right" CheckingForShort:true];
}

-(BOOL) breadthSearchFrom:(ComponentModel*)startComp To:(ComponentModel*)targetComp inDirection:(NSString*)direction CheckingForShort:(BOOL)checkForShort
{
    NSMutableArray* visited = [[NSMutableArray alloc] initWithCapacity:_numRows];
    
    // set visited table initally to all 0's
    for (int i = 0; i < _numRows; ++i) {
        NSMutableArray *visColumn = [[NSMutableArray alloc] initWithCapacity:_numCols];
        [visited addObject:visColumn];
        for (int j = 0; j < _numCols; ++j) {
            [visited[i] addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    [[visited objectAtIndex:[startComp getRow]] setObject:[NSNumber numberWithInt:1] atIndex:[startComp getCol]];
    
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
    
    // search for target
    while ([connectionQueue count] > 0) {
        ComponentModel* element = connectionQueue[0];
        [connectionQueue removeObjectAtIndex:0];
        
        int row = [element getRow];
        int col = [element getCol];
        [[visited objectAtIndex:row] setObject:[NSNumber numberWithInt:1] atIndex:col];
        
        // check for target
        if ([element isSameComponentAs:targetComp]) {
            return YES;
        }
        
        // Ignore a path with a lightbulb, emitter or bomb in the short case
        if (checkForShort) {
            if ([[element getType] isEqual:@"Bulb"] || [[element getType] isEqual:@"Emitter"] || [[element getType] isEqual:@"Bomb"]) {
                continue;
            }
        }
        
        // check left neighbor
        if ([element isConnectedLeft] && ![visited[row][col - 1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row][col-1]];
        }
        // check right neighbor
        if ([element isConnectedRight] && ![visited[row][col + 1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row][col+1]];
        }
        // check above neighbor
        if ([element isConnectedTop] && ![visited[row - 1][col] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row-1][col]];
        }
        // check below neighbor
        if ([element isConnectedBottom] && ![visited[row + 1][col] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:_grid[row+1][col]];
        }
    }
    return NO;
}

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

-(BOOL) isBombConnected
{
    NSArray* connectedBombLoc = [self getConnectedLocations:_bombs withState:NO];
    NSArray* connectedBombs = connectedBombLoc[0];
    return (connectedBombs.count > 0);
}

- (void) updateStateOfComponents:(NSArray*)components
{
    // Check conectivity for each bulb
    for (int i = 0; i < components.count; ++i) {
        
        ComponentModel* comp = components[i];
        
        NSArray* connections = [self getAllConnectionsTo:comp];
        
        // Make sure the component is valid
        NSAssert(connections.count == 2, @"Invalid number of connections to comp");
        
        // Check if the component is connected by battery following the two possible paths
        BOOL path1Pos = [self breadthSearchFrom:comp To:_batteryPos inDirection:connections[0] CheckingForShort:NO];
        BOOL path1Neg = [self breadthSearchFrom:comp To:_batteryNeg inDirection:connections[1] CheckingForShort:NO];
        BOOL path2Neg = [self breadthSearchFrom:comp To:_batteryNeg inDirection:connections[0] CheckingForShort:NO];
        BOOL path2Pos = [self breadthSearchFrom:comp To:_batteryPos inDirection:connections[1] CheckingForShort:NO];
        
        // If one of paths is built, set the state to on
        if ((path1Pos && path1Neg) || (path2Pos && path2Neg)) {
            [comp setState:YES];
            continue;
        }
        
        // Now check if the component is connected by a receiver
        if (![[comp getType] isEqual:@"Receiver"]) {
            for (int j = 0; j < _receivers.count; ++j){
                    
                BOOL path1 = [self breadthSearchFrom:comp To:_receivers[j] inDirection:connections[0] CheckingForShort:NO];
                BOOL path2 = [self breadthSearchFrom:comp To:_receivers[j] inDirection:connections[1] CheckingForShort:NO];
                
                if (path1 && path2 && [_receivers[j] getState]) {
                    [comp setState:YES];
                    break;
                } else {
                    [comp setState:NO];
                }
            }
        }
    }
}

- (NSArray*) getAllConnectionsTo:(ComponentModel*)component{

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

- (void) powerOn
{
    [_batteryPos setState:YES];
    [self resetComponents];
    
    [self updateStateOfComponents:_emitters];
    
    while (true) {
        [self updateLasers];

        [self updateStateOfComponents:_bulbs];
        [self updateStateOfComponents:_bombs];
        
        NSArray* emitterStates = [self stateOfEmitters];
        [self updateStateOfComponents:_emitters];
        if (![self didEmitterStateChange:emitterStates]) {
            break;
        }
    }
}

- (void) powerOff
{
    [_batteryPos setState:NO];
    [self resetComponents];
}

- (void) resetComponents
{
    [self reset:_emitters];
    [self reset:_bulbs];
    [self reset:_bombs];
    [self resetLasers];
}

- (NSArray*) stateOfEmitters
{
    NSMutableArray* states = [[NSMutableArray alloc] init];
    for (ComponentModel* comp in _emitters) {
        [states addObject:[NSNumber numberWithBool:[comp getState]]];
    }

    return states;
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

- (void) reset:(NSArray*)components
{
    for (ComponentModel* comp in components) {
        [comp setState:NO];
    }
}

- (int) getNumRows
{
    return _numRows;
}

- (int) getNumCols
{
    return _numCols;
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
