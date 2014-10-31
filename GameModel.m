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
    int _gridRows;
    int _gridCols;
    int _batteryRow;
    int _batteryPosCol;
    int _batteryNegCol;
    int _bulbRow;
    int _bulbCol;
    int _numLevels;
    //int _level;
}

@end

@implementation GameModel

-(id) init
{
    if (self == [super init]) {

        self.numRows = 15;
        self.numCols = 15;
        _gridRows = self.numRows * 2 - 1;
        _gridCols = self.numCols * 2 - 1; // The grid contains more data than the grid elements

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

-(void) clearGrid
{
    for (int x = 0; x < _grid.count; ++x) {
        [_grid[x] removeAllObjects];
    }
}

-(void) generateGrid: (NSInteger) level
{
    [self clearGrid];

    // Make sure that the input for this method is valid
    NSAssert((level <= _numLevels), @"Invalid level argument");
    NSAssert((level >= -2), @"Invalid level argument"); // <--Adjust this when testing to allow for test grids.

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
                _batteryRow = r;
                _batteryNegCol = c;
            } else if ([datum isEqual:@"4"]) {
                _bulbRow = r;
                _bulbCol = c;
            } else if ([datum isEqual:@"6"]) {
                _batteryPosCol = c;
            }

            [[_grid objectAtIndex:r] setObject:datum atIndex:c];
        }
    }
    
}

-(NSString*) getTypeAtRow:(int)row andCol:(int)col
{
    NSAssert((row <= _numRows) && (row >= 0), @"Invalid row argument"); // Make sure row input is valid
    NSAssert((col >= 0) && (col <= _numCols), @"Invalid col argument"); // Make sure col input is valid

    NSString* component = [[_grid objectAtIndex:2*row] objectAtIndex:2*col];
    NSString* compWithConn = [self getComponentWithConnectionsFor:[component intValue] AtRow:row andCol:col];
    
    return compWithConn;
}

// determine the component and what connections it has based on the type and the location
- (NSString*) getComponentWithConnectionsFor:(int)type AtRow:(int)row andCol:(int)col
{
    NSString* compWithConn;
    switch (type) {
            // blank case
        case 0:
        case 9:
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
            // No short case for now
            compWithConn = @"bulb";
            break;
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

-(BOOL) checkForShort
{
    NSArray* start = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryPosCol], nil];
    NSArray* end = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryNegCol], nil];
    
    return [self breadthSearchFrom:start To:end];
}

-(BOOL) breadthSearchFrom:(NSArray*)start To:(NSArray*)end
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
    
    // set up our queue
    NSMutableArray* connectionQueue = [[NSMutableArray alloc] init];
    [connectionQueue addObject:start];
    
    // target
    int targetRow = [end[0] intValue];
    int targetCol = [end[1] intValue];
    
    // search for target
    while ([connectionQueue count] > 0) {
        NSArray* position = connectionQueue[0];
        [connectionQueue removeObjectAtIndex:0];
        
        int row = [position[0] intValue];
        int col = [position[1] intValue];
        [[visited objectAtIndex:row / 2] setObject:[NSNumber numberWithInt:1] atIndex:col/2];
        
        // check for target
        if (row == targetRow && col == targetCol) {
            return YES;
        }
        // check left neighbor
        if ([_grid[row][col-1] isEqual:@"-"] && ![[[visited objectAtIndex:row/2]objectAtIndex:col/2-1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:col-2], nil]];
            visited[row/2][col/2-1] = [NSNumber numberWithInt:1];
        }
        // check right neighbor
        if ([_grid[row][col+1] isEqual:@"-"] && ![[[visited objectAtIndex:row/2]objectAtIndex:col/2+1] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:col+2], nil]];
            visited[row/2][col/2+1] = [NSNumber numberWithInt:1];
        }
        // check above neighbor
        if ([_grid[row-1][col] isEqual:@"|"] && ![[[visited objectAtIndex:row/2-1]objectAtIndex:col/2] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row-2], [NSNumber numberWithInt:col], nil]];
            visited[row/2-1][col/2] = [NSNumber numberWithInt:1];
        }
        // check below neighbor
        if ([_grid[row+1][col] isEqual:@"|"] && ![[[visited objectAtIndex:row/2+1]objectAtIndex:col/2] isEqual:[NSNumber numberWithInt:1]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row+2], [NSNumber numberWithInt:col], nil]];
            visited[row/2+1][col/2] = [NSNumber numberWithInt:1];
        }
    }
    
    return NO;
}

-(BOOL) connected
{

    NSArray* startPos = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryPosCol], nil];
    NSArray* startNeg = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryNegCol], nil];
    NSArray* end = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_bulbRow], [NSNumber numberWithInt:_bulbCol], nil];

    return [self breadthSearchFrom:startPos To:end] && [self breadthSearchFrom:startNeg To:end];
}

/*
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
 */

@end
