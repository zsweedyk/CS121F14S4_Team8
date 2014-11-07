//
//  GameModel.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "GameModel.h"

@interface GameModel()
{
    NSMutableArray* _grid;
    NSMutableArray *_bulbs;

    int _gridRows;
    int _gridCols;
    int _batteryRow;
    int _batteryPosCol;
    int _batteryNegCol;

    int _numLevels; // total number of levels
}

@end

@implementation GameModel

-(id) initWithTotalLevels:(int)totalLevels
{
    _numLevels = totalLevels;
    
    if (self = [super init]) {
        
        self.numRows = 15;
        self.numCols = 15;
        _gridRows = self.numRows * 2 - 1;
        _gridCols = self.numCols * 2 - 1; // The grid contains more data than the grid elements
        _bulbs = [[NSMutableArray alloc] init];
        
        // initialize arrays with enough space for all the data in the rows
        _grid = [[NSMutableArray alloc] initWithCapacity:_gridRows];
        
        // in each row spot add another array for the columns
        for (int r = 0; r < _gridRows; ++r) {
            NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity:_gridCols];
            [_grid addObject:column];
        }
    }
    
    return self;
}

-(void) clearGridAndBulbs
{
    for (int x = 0; x < _grid.count; ++x) {
        [_grid[x] removeAllObjects];
    }
    [_bulbs removeAllObjects];
}

// assumptions: level is in [-3, numLevels]
-(void) generateGrid: (NSInteger) level
{
    [self clearGridAndBulbs];
    
    // Make sure that the input for this method is valid
    NSAssert((level <= _numLevels), @"Invalid level argument");
    NSAssert((level >= -3), @"Invalid level argument"); // <--Adjust this when testing to allow for test grids.
    
    // get the txt file with the grid data
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"level%d",level] ofType:@""];
    NSError* error;
    
    // Read grids from text file
    NSString* data = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    for (int r = 0; r < _gridRows; ++r) {
        NSRange range = NSMakeRange(r*(_gridCols + 2), _gridCols); // the range for a row worth of data
        NSString* rowData = [data substringWithRange:range];
        
        for (int c = 0; c < _gridCols; ++c) {
            
            NSString* datum = [rowData substringWithRange:NSMakeRange(c, 1)];
            
            // Find the battery and bulbs in the grid and store their location
            if ([datum isEqual:@"3"]) {
                _batteryRow = r/2;
                _batteryNegCol = c/2;
            } else if ([datum isEqual:@"4"]) {
                NSArray* bulb = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:r/2], [NSNumber numberWithInt:c/2], nil];
                [_bulbs addObject:bulb];
            } else if ([datum isEqual:@"6"]) {
                _batteryPosCol = c/2;
            }
            
            [[_grid objectAtIndex:r] setObject:datum atIndex:c];
        }
    }
    
    //For debug
    //[self printGrid];
}

// assumption: row is in [0, _numRows]; col is in [0, _numCols]
-(NSString*) getTypeAtRow:(int)row andCol:(int)col
{
    NSAssert((row <= _numRows) && (row >= 0), @"Invalid row argument"); // Make sure row input is valid
    NSAssert((col >= 0) && (col <= _numCols), @"Invalid col argument"); // Make sure col input is valid
    
    NSString* component = [[_grid objectAtIndex:2*row] objectAtIndex:2*col];

    // find the connections the component has
    NSString* compWithConn = [self getComponentWithConnectionsFor:[component intValue] AtRow:row andCol:col];
    
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
- (NSString*) getComponentWithConnectionsFor:(int)type AtRow:(int)row andCol:(int)col
{
    NSString* compWithConn;
    switch (type) {
        // blank case
        case 0:
            compWithConn = @"blank";
            break;
        // wire case
        case 1:
            compWithConn = [@"wire" stringByAppendingString:[self getConnectionsAtRow:row andCol:col]];
            break;
        // negative battery
        case 3:
            compWithConn = [@"batteryNeg" stringByAppendingString:[self getConnectionsAtRow:row andCol:col]];
            break;
        // positive battery
        case 6:
            compWithConn = [@"batteryPos" stringByAppendingString:[self getConnectionsAtRow:row andCol:col]];
            break;
        case 4:
        // bulb case
            compWithConn = @"bulb";
            break;
        // switch case
        case 7:
            compWithConn = @"switch";
            break;
        default:
            break;
    }
    
    return compWithConn;
}

-(void) setValueAtRow: (int) row andCol: (int) col withValue: (NSString*) value
{
    _grid[2*row][2*col] = value;
}

-(NSString*) getConnectionsAtRow:(int)row andCol:(int)col
{
    
    NSString* connections = @"";
    
    // connected to the left or switch to the left
    if ([_grid[2*row][2*col-1]  isEqual: @"-"] || [_grid[2*row][2*col-2] isEqual:@"7"]) {
        connections = [connections stringByAppendingString:@"L"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }
    // connected to the right or switch to the right
    if ([_grid[2*row][2*col+1]  isEqual: @"-"] || [_grid[2*row][2*col+2] isEqual:@"7"]) {
        connections = [connections stringByAppendingString:@"R"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }
    // connected above or switch above
    if ([_grid[2*row-1][2*col]  isEqual: @"|"] || [_grid[2*row-2][2*col] isEqual:@"7"]) {
        connections = [connections stringByAppendingString:@"T"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }
    // connected below or switch below
    if ([_grid[2*row+1][2*col]  isEqual: @"|"] || [_grid[2*row+2][2*col] isEqual:@"7"]) {
        connections = [connections stringByAppendingString:@"B"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }
    
    return connections;
}

// Update the grid with the connection of the switch
-(void) switchSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation
{
    NSRegularExpression *orientationForm = [[NSRegularExpression alloc] initWithPattern:@"[LX][RX][TX][BX]" options:0 error:nil];
    int numMatchesToForm = [orientationForm numberOfMatchesInString:newOrientation options:0 range:NSMakeRange(0, 4)];
    NSAssert(numMatchesToForm == 1, @"Invalid orientation argument"); // Make sure orientation input is valid
    
    // Make sure row and col input is valid
    NSAssert((row <= _numRows) && (row >= 0), @"Invalid row argument");
    NSAssert((col >= 0) && (col <= _numCols), @"Invalid col argument");
    
    // Make sure that row and col describe switch location
    NSAssert([_grid[2*row][2*col] isEqual:@"7"], @"Input location does not correspond to switch");
    
    // As long as location is not left most column, adjust left cell
    if  (col != 0) {
        if ([[newOrientation substringWithRange:NSMakeRange(0, 1)] isEqual:@"L"]) {
            _grid[2 * row][2 * col - 1] = @"-";
        } else {
            _grid[2 * row][2 * col - 1] = @" ";
        }
    }
    
    // As long as location is not right most column, adjust right cell
    if (col != _numCols-1) {
        if ([[newOrientation substringWithRange:NSMakeRange(1, 1)] isEqual:@"R"]) {
            _grid[2 * row][2 * col + 1] = @"-";
        } else {
            _grid[2 * row][2 * col + 1] = @" ";
        }
    }
    
    // As long as location is not upper most row, adjust above cell
    if (row != 0) {
        if ([[newOrientation substringWithRange:NSMakeRange(2, 1)] isEqual:@"T"]) {
            _grid[2 * row - 1][2 * col] = @"|";
        } else {
            _grid[2 * row - 1][2 * col] = @" ";
        }
    }
    
    // As long as location is not lower most row, adjust below cell
    if (row != _numRows - 1) {
        if ([[newOrientation substringWithRange:NSMakeRange(3, 1)] isEqual:@"B"]) {
            _grid[2 * row + 1][2 * col] = @"|";
        } else {
            _grid[2 * row + 1][2 * col] = @" ";
        }
    }
    
}

-(BOOL) shorted
{
    // check if two nodes of battery are connected directly
    NSArray* start = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryPosCol], nil];
    NSArray* end = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryNegCol], nil];
 
    return [self breadthSearchFrom:end To:start withDirection:@"R"];
}

-(BOOL) breadthSearchFrom:(NSArray*)bulb To:(NSArray*)battery withDirection:(NSString*)direction
{
    NSMutableArray* visited = [[NSMutableArray alloc] initWithCapacity:self.numRows];
    
    // set visited table initally to all 0's
    for (int i = 0; i < self.numRows; ++i) {
        NSMutableArray *visColumn = [[NSMutableArray alloc] initWithCapacity:self.numCols];
        [visited addObject:visColumn];
        for (int j = 0; j < self.numCols; ++j) {
            [visited[i] addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    [[visited objectAtIndex:[bulb[0] intValue]] setObject:[NSNumber numberWithInt:1] atIndex:[bulb[1] intValue]];
    
    // set up our queue
    NSMutableArray* connectionQueue = [[NSMutableArray alloc] init];
    
    // Add the first element given the direction of travel from light bulb
    NSArray* firstObject;
    if ([direction isEqual:@"L"]) {
        firstObject = [[NSArray alloc] initWithObjects:bulb[0], [NSNumber numberWithInt:[bulb[1] intValue] - 1], nil];
    } else if ([direction isEqual:@"R"]) {
        firstObject = [[NSArray alloc] initWithObjects:bulb[0], [NSNumber numberWithInt:[bulb[1] intValue] + 1], nil];
    } else if ([direction isEqual:@"T"]) {
        firstObject = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[bulb[0] intValue] - 1], bulb[1], nil];
    } else {
        firstObject = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[bulb[0] intValue] + 1], bulb[1], nil];
    }
    [connectionQueue addObject:firstObject];
    
    // target
    int targetRow = [battery[0] intValue];
    int targetCol = [battery[1] intValue];
    
    // search for target
    while ([connectionQueue count] > 0) {
        NSArray* position = connectionQueue[0];
        [connectionQueue removeObjectAtIndex:0];
        
        int row = [position[0] intValue];
        int col = [position[1] intValue];
        [[visited objectAtIndex:row] setObject:[NSNumber numberWithInt:1] atIndex:col];
        
        // check for target
        if (row == targetRow && col == targetCol) {
            return YES;
        }
        // check left neighbor
        if ([_grid[2*row][2*col-1] isEqual:@"-"] && ![[[visited objectAtIndex:row]objectAtIndex:col-1] isEqual:[NSNumber numberWithInt:1]]
            && ![_grid[2*row][2*col-2] isEqual:@"4"]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:col-1], nil]];
            visited[row][col-1] = [NSNumber numberWithInt:1];
        }
        // check right neighbor
        if ([_grid[2*row][2*col+1] isEqual:@"-"] && ![[[visited objectAtIndex:row]objectAtIndex:col+1] isEqual:[NSNumber numberWithInt:1]]
            && ![_grid[2*row][2*col+2] isEqual:@"4"]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:col+1], nil]];
            visited[row][col+1] = [NSNumber numberWithInt:1];
        }
        // check above neighbor
        if ([_grid[2*row-1][2*col] isEqual:@"|"] && ![[[visited objectAtIndex:row-1]objectAtIndex:col] isEqual:[NSNumber numberWithInt:1]]
            && ![_grid[2*row - 2][2*col] isEqual:@"4"]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row-1], [NSNumber numberWithInt:col], nil]];
            visited[row-1][col] = [NSNumber numberWithInt:1];
        }
        // check below neighbor
        if ([_grid[2*row+1][2*col] isEqual:@"|"] && ![[[visited objectAtIndex:row+1]objectAtIndex:col] isEqual:[NSNumber numberWithInt:1]]
            && ![_grid[2*row + 2][2*col] isEqual:@"4"]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row+1], [NSNumber numberWithInt:col], nil]];
            visited[row+1][col] = [NSNumber numberWithInt:1];
        }
    }
    
    return NO;
}

-(BOOL) connected
{
    
    NSArray* battPos = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryPosCol], nil];
    NSArray* battNeg = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryNegCol], nil];
    
    
    // Check conenctivity for each bulb
    for (int i = 0; i < _bulbs.count; ++i) {
        
        // Find which paths we can follow from the bulb
        NSMutableArray* pathStarts = [[NSMutableArray alloc] init];
        NSString* directions = [self getConnectionsAtRow:[_bulbs[i][0] intValue] andCol:[_bulbs[i][1] intValue]];
        for(int j = 0; j < 4; ++j) {
            NSString* dir = [directions substringWithRange:NSMakeRange(j, 1)];
            if (![dir isEqual:@"X"]) {
                [pathStarts addObject:dir];
            }
        }
        
        // Make sure the bulb is valid on the grid
        NSAssert([pathStarts count] == 2, @"Invalid number of connections to bulb at row:, and col:");
        
        // See if the bulb is connected following the two possible paths
        bool path1 = [self breadthSearchFrom:_bulbs[i] To:battPos withDirection:pathStarts[0]] && [self breadthSearchFrom:_bulbs[i] To:battNeg withDirection:pathStarts[1]];
        bool path2 = [self breadthSearchFrom:_bulbs[i] To:battNeg withDirection:pathStarts[0]] && [self breadthSearchFrom:_bulbs[i] To:battPos withDirection:pathStarts[1]];
        
        // If it's not at least one of the possible paths then it's false
        if (!(path1 || path2)) {
            return false;
        }
        
    }
    return true;
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
