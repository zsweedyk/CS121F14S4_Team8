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
    NSMutableArray* connectedBulbs;
    NSMutableArray* connectedBombs;

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
        _bulbs = [[NSMutableArray alloc] init];
        _bombs = [[NSMutableArray alloc] init];
        
        // initialize arrays with enough space for all the data in the rows
        _grid = [[NSMutableArray alloc] init];
        
        // in each row spot add another array for the columns
        for (int r = 0; r < _numRows; ++r) {
            NSMutableArray *column = [[NSMutableArray alloc] init];
            [_grid addObject:column];
        }
        _lasers = [[NSMutableArray alloc] init];
        //initialize component arrays
        _emitters = [[NSMutableArray alloc] init];
        
        _deflectors = [[NSMutableArray alloc] init];
        
        _receivers = [[NSMutableArray alloc] init];
    }
    
    return self;
}


// assumptions: level is in [-3, numLevels]
-(void) generateGrid: (int) level
{
    [self clearGridAndBulbs];
    
    // Make sure that the input for this method is valid
    NSAssert((level <= _numLevels), @"Invalid level argument");
    NSAssert((level >= -3), @"Invalid level argument"); // <--Adjust this when testing to allow for test grids.
    
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
-(void) clearGridAndBulbs
{
    for (int x = 0; x < _grid.count; ++x) {
        [_grid[x] removeAllObjects];
    }

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
                component = [[ComponentModel  alloc] initOfType:@"Wire" AtRow:r AndCol:c AndState:@"Off"];
            } else if ([datum isEqual:@"3"]) {
                component = [[ComponentModel  alloc] initOfType:@"BatteryNeg" AtRow:r AndCol:c AndState:@"Off"];
                _batteryNeg = component;
            } else if ([datum isEqual:@"4"]) {
                component = [[ComponentModel  alloc] initOfType:@"Bulb" AtRow:r AndCol:c AndState:@"Off"];
                [_bulbs addObject:component];
            } else if ([datum isEqual:@"6"]) {
                component = [[ComponentModel  alloc] initOfType:@"BatteryPos" AtRow:r AndCol:c AndState:@"Off"];
                _batteryPos = component;
            } else if ([datum isEqual:@"7"]) {
                component = [[ComponentModel  alloc] initOfType:@"Switch" AtRow:r AndCol:c AndState:@"Off"];
            } else if ([datum isEqual:@"2"]) //code for laser components
            {
                component = [[ComponentModel alloc] initOfType:@"Emitter" AtRow:r AndCol:c AndState:@"Off"];
                [_emitters addObject:component];
            } else if ([datum isEqual:@"5"]) {
                component = [[ComponentModel alloc] initOfType:@"Receiver" AtRow:r AndCol:c AndState:@"Off"];
                [_receivers addObject:component];
            } else if ([datum isEqual:@"8"]) {
                component = [[ComponentModel alloc] initOfType:@"Deflector" AtRow:r AndCol:c AndState:@"Off"];
                [component pointTo:@"XRTX"];
                [_deflectors addObject:component];
            } else if ([datum isEqual:@"9"]) {
                component = [[ComponentModel  alloc] initOfType:@"Bomb" AtRow:r AndCol:c AndState:@"Off"];
                [_bombs addObject:component];
            } else {
                component = [[ComponentModel  alloc] initOfType:@"Empty" AtRow:r AndCol:c AndState:@"Off"];
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
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] connectedRight:true];
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] connectedLeft:true];
                [[[_grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] connectedBottom:true];
                [[[_grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] connectedTop:true];
            } else if ([datum isEqual:@"+"]) {
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c - 1)/2] pointTo:@"R"];
                [[[_grid objectAtIndex:r/2] objectAtIndex:(c + 1)/2] pointTo:@"L"];
            } else if ([datum isEqual:@"*"]) {
                [[[_grid objectAtIndex:(r - 1)/2] objectAtIndex:c/2] pointTo:@"D"];
                [[[_grid objectAtIndex:(r + 1)/2] objectAtIndex:c/2] pointTo:@"U"];
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
// 3: negative battery
// 6: positive battery
// 4: bulb
// 7: switch
// 9: bomb
- (NSString*) getComponentWithConnectionsFor:(ComponentModel*)component
{
    // Get typ and location from component
    NSString* type = [component getType];

    NSString* connections = [self getConnectionsFor:component Laser:NO];
    NSString* laserconnections = [self getConnectionsFor:component Laser:YES];

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
    } else if ( [type isEqual:@"Emitter"]) {
        compWithConn = [@"emitter" stringByAppendingString:laserconnections];
    } else if ( [type isEqual:@"Receiver"]) {
        compWithConn = [@"receiver" stringByAppendingString:laserconnections];
    } else if ( [type isEqual:@"Deflector"]) {
        compWithConn = @"deflector";
    } else if ( [type isEqual:@"Bomb"] ) {
        compWithConn = [@"bomb" stringByAppendingString:connections];
    }
    else {
        compWithConn = @"empty";
    }
    return compWithConn;
}

// These connections are for imagename generation so we include the possibility of being connected to a switch
-(NSString*) getConnectionsFor:(ComponentModel*)component Laser:(BOOL)laser
{
    
    NSString* connections = @"";
    //Check for laser connections
    if(laser){
        if( [[component direction] isEqual:@"U"]){
            connections = [connections stringByAppendingString:@"Top"];
        }else if([[component direction] isEqual:@"D"]){
            connections = [connections stringByAppendingString:@"Bottom"];
        }else if([[component direction] isEqual:@"L"]){
            connections = [connections stringByAppendingString:@"Left"];
        }else if([[component direction] isEqual:@"R"]){
            connections = [connections stringByAppendingString:@"Right"];
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

- (bool) hasSwitchTo:(NSString*)direction OfComponent:(ComponentModel*)component
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
-(void) switchSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation
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
    NSAssert([[component getType] isEqual:@"Switch"], @"Input location does not correspond to switch");
    
    // As long as location is not left most column, adjust left cell
    if ( col != 0 ) {
        if ([[newOrientation substringWithRange:NSMakeRange(0, 1)] isEqual:@"L"]) {
            [component connectedLeft:true];
            [_grid[row][col - 1] connectedRight:true];
        } else {
            [component connectedLeft:false];
            [_grid[row][col - 1] connectedRight:false];
        }
    }
    
    // As long as location is not right most column, adjust right cell
    if ( col != _numCols-1 ) {
        if ([[newOrientation substringWithRange:NSMakeRange(1, 1)] isEqual:@"R"]) {
            [component connectedRight:true];
            [_grid[row][col + 1] connectedLeft:true];
        } else {
            [component connectedRight:false];
            [_grid[row][col + 1] connectedLeft:false];
        }
    }
    
    // As long as location is not upper most row, adjust above cell
    if (row != 0) {
        if ([[newOrientation substringWithRange:NSMakeRange(2, 1)] isEqual:@"T"]) {
            [component connectedTop:true];
            [_grid[row - 1][col] connectedBottom:true];
        } else {
            [component connectedTop:false];
            [_grid[row - 1][col] connectedBottom:false];
        }
    }
    
    // As long as location is not lower most row, adjust below cell
    if (row != _numRows - 1) {
        if ([[newOrientation substringWithRange:NSMakeRange(3, 1)] isEqual:@"B"]) {
            [component connectedBottom:true];
            [_grid[row + 1][col] connectedTop:true];
        } else {
            [component connectedBottom:false];
            [_grid[row + 1][col] connectedTop:false];
        }
    }
    
}

-(void) deflectorSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation
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
    NSAssert([[component getType] isEqual:@"Deflector"], @"Input location does not correspond to deflector");
    
    [component pointTo:newOrientation];
}

-(NSArray*)emitters{
    return _emitters;
}
-(NSArray*)deflectors{
    return _deflectors;
}
-(NSArray*)receivers{
    return _receivers;
}

-(NSArray*)getLaserPath
{
    [_lasers removeAllObjects];
    
    for(int i = 0;i<_deflectors.count;i++){
        [_deflectors[i] setState:@"Off"];
    }
    for(int i = 0;i<_receivers.count;i++){
        [_receivers[i] setState:@"Off"];
    }
    for(int i = 0;i<_emitters.count;i++){
        [self getLaserPathAtComp:_emitters[i]];
    }
    return _lasers;
}

- (void) getLaserPathAtComp:(ComponentModel*)comp
{
    NSAssert([[comp getType] isEqual:@"Emitter"], @"Input location does not correspond to emitter");
    NSAssert([[comp direction] isEqual:@"U"]||[[comp direction] isEqual:@"D"]||[[comp direction] isEqual:@"L"]||[[comp direction] isEqual:@"R"],@"illegal direction");
    int emRow = [comp getRow];
    int emCol = [comp getCol];
    if([[comp getState] isEqual:@"On"]){
        NSString* dir = [comp direction];
        
        if([dir isEqual:@"U"])
            [self createLaserTopAtRow:emRow Col:emCol];
        else if ([dir isEqual:@"D"])
            [self createLaserBotAtRow:emRow Col:emCol];
        else if ([dir isEqual:@"L"])
            [self createLaserLeftAtRow:emRow Col:emCol];
        else if ([dir isEqual:@"R"])
            [self createLaserRightAtRow:emRow Col:emCol];
    }
}

- (void) createLaserTopAtRow:(int)row Col:(int)col
{
    while ((row>1)&&([[_grid[row-1][col] getType] isEqual:@"Empty"])){
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"Beam" AtRow:row-1 AndCol:col AndState:@"laserXXTB"];
        [_lasers addObject:comp];
        row = row-1;
    }
 
    row = row-1;
    ComponentModel *obstacle = _grid[row][col];
    
    if([[obstacle getType] isEqual:@"Deflector"]){
    
        if([[obstacle direction] isEqual:@"LXXB"]){
            [obstacle setState:@"On"];
            [self createLaserLeftAtRow:row Col:col];
        }else if([[obstacle direction] isEqual:@"XRXB"]){
            [obstacle setState:@"On"];
            [self createLaserRightAtRow:row Col:col];
        }else{
            [obstacle setState:@"Off"];
        }
    }else if([[obstacle getType] isEqual:@"Receiver"]){
      
        if([[obstacle direction] isEqual:@"D"]){
            [obstacle setState:@"On"];
        }
    }
}

- (void) createLaserBotAtRow:(int)row Col:(int)col
{
    while ((row<13)&&([[_grid[row+1][col] getType] isEqual:@"Empty"])){
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"Beam" AtRow:row+1 AndCol:col AndState:@"laserXXTB"];
        [_lasers addObject:comp];
        row = row+1;
    }
 
    row = row+1;
    ComponentModel *obstacle = _grid[row][col];
    
    if([[obstacle getType] isEqual:@"Deflector"]){
    
        if([[obstacle direction] isEqual:@"LXTX"]){
            [obstacle setState:@"On"];
            [self createLaserLeftAtRow:row Col:col];
        }else if([[obstacle direction] isEqual:@"XRTX"]){
            [obstacle setState:@"On"];
            [self createLaserRightAtRow:row Col:col];
        }else{
            [obstacle setState:@"Off"];
        }
    }else if([[obstacle getType] isEqual:@"Receiver"]){
        
        if([[obstacle direction] isEqual:@"U"]){
            [obstacle setState:@"On"];
        }
    }
}

- (void) createLaserLeftAtRow:(int)row Col:(int)col
{
    while ((col>1)&&([[_grid[row][col-1] getType] isEqual:@"Empty"])){
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"Beam" AtRow:row AndCol:col-1 AndState:@"laserLRXX"];
        [_lasers addObject:comp];
        col = col-1;
    }
   
    col = col-1;
    ComponentModel *obstacle = _grid[row][col];
    
    if([[obstacle getType] isEqual:@"Deflector"]){
    
        if([[obstacle direction] isEqual:@"XRTX"]){
            [obstacle setState:@"On"];
            [self createLaserTopAtRow:row Col:col];
        }else if([[obstacle direction] isEqual:@"XRXB"]){
            [obstacle setState:@"On"];
            [self createLaserBotAtRow:row Col:col];
        }else{
            [obstacle setState:@"Off"];
        }
    }else if([[obstacle getType] isEqual:@"Receiver"]){
        
        if([[obstacle direction] isEqual:@"R"]){
            [obstacle setState:@"On"];
        }
    }
}


- (void) createLaserRightAtRow:(int)row Col:(int)col
{
    while ((col<13)&&([[_grid[row][col+1] getType] isEqual:@"Empty"])){
        
        ComponentModel *comp = [[ComponentModel alloc] initOfType:@"Beam" AtRow:row AndCol:col+1 AndState:@"laserLRXX"];
        [_lasers addObject:comp];
        col = col+1;
    }
    
    col = col+1;
    ComponentModel *obstacle = _grid[row][col];
    
    if([[obstacle getType] isEqual:@"Deflector"]){
    
        if([[obstacle direction] isEqual:@"LXTX"]){
            [obstacle setState:@"On"];
            [self createLaserTopAtRow:row Col:col];
        }else if([[obstacle direction] isEqual:@"LXXB"]){
            [obstacle setState:@"On"];
            [self createLaserBotAtRow:row Col:col];
        }else{
            [obstacle setState:@"Off"];
        }
    } else if([[obstacle getType] isEqual:@"Receiver"]){
     
        if([[obstacle direction] isEqual:@"L"]){
            [obstacle setState:@"On"];
        }
    }
}


-(BOOL) shorted
{
    // check if two nodes of battery are connected directly
    return [self breadthSearchFrom:_batteryNeg To:_batteryPos inDirection:@"Right" CheckingForShort:true];
}

-(BOOL) breadthSearchFrom:(ComponentModel*)startComp To:(ComponentModel*)targetComp inDirection:(NSString*)direction CheckingForShort:(bool)checkForShort
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
        // Ignore a path with a lightbulb in the short case
        if ((checkForShort && [[element getType] isEqual:@"Bulb"])||(checkForShort && [[element getType] isEqual:@"Emitter"])) {
            continue;
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

-(NSArray*) connectedBombs
{
    // store the indices of all connected bulbs
    connectedBombs = [[NSMutableArray alloc] init];
    
    // Check conenctivity for each bulb
    for (int i = 0; i < _bombs.count; ++i) {
        
        // Make sure bulbs are actually bulbs
        ComponentModel* bomb = _bombs[i];
        NSAssert([[bomb getType] isEqual:@"Bomb"], @"Elements in bulb array are not actually bulbs");
        
        NSArray* connections = [self getAllConnectionsTo:bomb];
        
        // Make sure the bulb is valid on the grid
        NSAssert(connections.count == 2, @"Invalid number of connections to bulb");
        
        // See if the bulb is connected following the two possible paths
        bool path1Pos = [self breadthSearchFrom:bomb To:_batteryPos inDirection:connections[0] CheckingForShort:false];
        bool path1Neg = [self breadthSearchFrom:bomb To:_batteryNeg inDirection:connections[1] CheckingForShort:false];
        bool path2Neg = [self breadthSearchFrom:bomb To:_batteryNeg inDirection:connections[0] CheckingForShort:false];
        bool path2Pos = [self breadthSearchFrom:bomb To:_batteryPos inDirection:connections[1] CheckingForShort:false];
        
        // If one of paths is bult, add the index of the bulb to an array
        if ((path1Pos && path1Neg) || (path2Pos && path2Neg))
            [connectedBombs addObject:[NSNumber numberWithInt:i]];
    }
    
    return connectedBombs;
}

-(BOOL) connected
{
    // store the indices of all connected bulbs
    connectedBulbs = [[NSMutableArray alloc] init];
    
    BOOL connectedToReceiver = NO;

    // Check conenctivity for each bulb
    for (int i = 0; i < _bulbs.count; ++i) {

        // Make sure bulbs are actually bulbs
        ComponentModel* bulb = _bulbs[i];
        NSAssert([[bulb getType] isEqual:@"Bulb"], @"Elements in bulb array are not actually bulbs");

        NSArray* connections = [self getAllConnectionsTo:bulb];

        // Make sure the bulb is valid on the grid
        NSAssert(connections.count == 2, @"Invalid number of connections to bulb");

        // See if the bulb is connected following the two possible paths
        bool path1Pos = [self breadthSearchFrom:bulb To:_batteryPos inDirection:connections[0] CheckingForShort:false];
        bool path1Neg = [self breadthSearchFrom:bulb To:_batteryNeg inDirection:connections[1] CheckingForShort:false];
        bool path2Neg = [self breadthSearchFrom:bulb To:_batteryNeg inDirection:connections[0] CheckingForShort:false];
        bool path2Pos = [self breadthSearchFrom:bulb To:_batteryPos inDirection:connections[1] CheckingForShort:false];
        
        // If one of paths is bult, add the index of the bulb to an array
        if ((path1Pos && path1Neg) || (path2Pos && path2Neg))
            [connectedBulbs addObject:[NSNumber numberWithInt:i]];

        for (int j = 0;j<_receivers.count;j++){
            if([[_receivers[j] getState] isEqual:@"On"]){
                bool path1 = [self breadthSearchFrom:bulb To:_receivers[j] inDirection:connections[0] CheckingForShort:false];
                bool path2 = [self breadthSearchFrom:bulb To:_receivers[j] inDirection:connections[1] CheckingForShort:false];
                
                if(path1&&path2)
                {
                    connectedToReceiver = YES;
                    [connectedBulbs addObject:[NSNumber numberWithInt:i]];
                }
            }
        }
    }
    
    if ((connectedBulbs.count == _bulbs.count) || connectedToReceiver)
        return true;
    else
        return false;
}

- (NSArray*) bulbIndices {
    return connectedBulbs;
}

-(void) checkEmitterConnection
{
    // Check conenctivity for each bulb
    BOOL connectedToReceiver = NO;
    
    for (int i = 0; i<_emitters.count;i++) {
        [_emitters[i] setState:@"Off"];
    }
    for (int i = 0; i < _emitters.count; ++i) {
        
        // Make sure bulbs are actually bulbs
        ComponentModel* emitter = _emitters[i];
        NSAssert([[emitter getType] isEqual:@"Emitter"], @"Elements in emitter array are not actually emitters");
        
        NSArray* connections = [self getAllConnectionsTo:emitter];
        
        // Make sure the bulb is valid on the grid
        NSAssert(connections.count == 2, @"Invalid number of connections to connections");
        
        // See if the bulb is connected following the two possible paths
        bool path1Pos = [self breadthSearchFrom:emitter To:_batteryPos inDirection:connections[0] CheckingForShort:false];
        bool path1Neg = [self breadthSearchFrom:emitter To:_batteryNeg inDirection:connections[1] CheckingForShort:false];
        bool path2Neg = [self breadthSearchFrom:emitter To:_batteryNeg inDirection:connections[0] CheckingForShort:false];
        bool path2Pos = [self breadthSearchFrom:emitter To:_batteryPos inDirection:connections[1] CheckingForShort:false];
        
        for (int i = 0;i<_receivers.count;i++){
            if([[_receivers[i] getState] isEqual:@"On"]){
                bool path1 = [self breadthSearchFrom:emitter To:_receivers[i] inDirection:connections[0] CheckingForShort:false];
                bool path2 = [self breadthSearchFrom:emitter To:_receivers[i] inDirection:connections[1] CheckingForShort:false];
                if(path1&&path2){
                    connectedToReceiver = YES;
                }
            }
        }
        
        // If it's not at least one of the possible paths then it's false
        if ((path1Pos && path1Neg) || (path2Pos && path2Neg) || connectedToReceiver) {
            //atLeastOneConnected = YES;
            [emitter setState:@"On"];
        }
    }
    
}

- (NSArray*) getAllConnectionsTo:(ComponentModel*)component{

    NSMutableArray* connections = [[NSMutableArray alloc] init];

    if ( [component isConnectedLeft] || [self hasSwitchTo:@"Left" OfComponent:component] ) {
        [connections addObject:@"Left"];
    }
    if ( [component isConnectedRight] ||[self hasSwitchTo:@"Right" OfComponent:component] ) {
        [connections addObject:@"Right"];
    }
    if ( [component isConnectedTop] || [self hasSwitchTo:@"Top" OfComponent:component] ) {
        [connections addObject:@"Top"];
    }
    if ( [component isConnectedBottom] || [self hasSwitchTo:@"Bottom" OfComponent:component] ) {
        [connections addObject:@"Bottom"];
    }

    return connections;
}

- (int) getNumRows
{
    return _numRows;
}

- (int) getNumCols
{
    return _numCols;
}


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
}


@end
