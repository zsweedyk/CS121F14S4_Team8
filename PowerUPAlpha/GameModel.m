//
//  GameModel.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "GameModel.h"

@interface GameModel()
{
    NSMutableArray* _grid;
    int _batteryRow;
    int _batteryPosCol;
    int _batteryNegCol;
    int _bulbRow;
    int _bulbCol;
    //int _level;
    
    NSMutableArray* _visited; // table for BFS
}

@end

@implementation GameModel

-(void) generateGrid: (NSInteger) level
{
    self.numRows = 15;
    self.numCols = 15;
    int gridRows = self.numRows*2 - 1;
    int gridCols = self.numCols*2 - 1; // The grid contains more data than the grid elements
    
    // initialize arrays with enough space for all the data in the rows
    _grid = [[NSMutableArray alloc] initWithCapacity:gridRows];
    _visited = [[NSMutableArray alloc] initWithCapacity:self.numRows];
    
    // in each row spot add another array for the columns
    for (int r = 0; r < gridRows; ++r) {
        NSMutableArray* column = [[NSMutableArray alloc] initWithCapacity:gridCols];
        [_grid addObject:column];
        
        NSMutableArray* visColumn = [[NSMutableArray alloc] initWithCapacity:self.numCols];
        [_visited addObject:visColumn];
    }
    
    // get the txt file with the grid data
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"level%d",level] ofType:@""];
    NSError* error;
    
    // Read grids from text file
    NSString* data = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    for (int r = 0; r < gridRows; ++r) {
        NSRange range = NSMakeRange(r*(gridCols + 2), gridCols); // the range for a row worth of data
        NSString* rowData = [data substringWithRange:range];
        
        for (int c = 0; c < gridCols; ++c) {
            NSString* datum = [rowData substringWithRange:NSMakeRange(c, 1)];
            [[_grid objectAtIndex:r] setObject:datum atIndex:c];
        }
    }

}

-(NSString*) getTypeAtRow:(int)row andCol:(int)col
{
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
        // neagtive battery
        case 3:
            compWithConn = [@"batteryNeg" stringByAppendingString:[self getConnectionsAtRow:row andCol:col]];
            _batteryRow = row;
            _batteryNegCol = col;
            break;
        // positive battery
        case 6:
            compWithConn = [@"batteryPos" stringByAppendingString:[self getConnectionsAtRow:row andCol:col]];
            _batteryPosCol = col;
            break;
        case 4:
            // No short case for now
            compWithConn = @"bulb";
            _bulbRow = row;
            _bulbCol = col;
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
    if ([[newOrientation substringWithRange:NSMakeRange(0, 1)] isEqual:@"L"]) {
        _grid[2*row][2*col-1] = @"-";
    } else {
        _grid[2*row][2*col-1] = @" ";
    }
    
    if ([[newOrientation substringWithRange:NSMakeRange(1, 1)] isEqual:@"R"]) {
        _grid[2*row][2*col+1] = @"-";
    } else {
        _grid[2*row][2*col+1] = @" ";
    }
    
    if ([[newOrientation substringWithRange:NSMakeRange(2, 1)] isEqual:@"T"]) {
        _grid[2*row-1][2*col] = @"|";
    } else {
        _grid[2*row-1][2*col] = @" ";
    }
    
    if ([[newOrientation substringWithRange:NSMakeRange(3, 1)] isEqual:@"B"]) {
        _grid[2*row+1][2*col] = @"|";
    } else {
        _grid[2*row+1][2*col] = @" ";
    }
    
}

-(BOOL) checkForShort
{
    NSArray* start = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryPosCol], nil];
    NSArray* end = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryNegCol], nil];
    
    return [self breadthSearchFrom:start To:end];
}

-(BOOL) checkForComplete
{
    NSArray* startPos = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryPosCol], nil];
    NSArray* startNeg = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_batteryRow], [NSNumber numberWithInt:_batteryNegCol], nil];
    NSArray* end = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_bulbRow], [NSNumber numberWithInt:_bulbCol], nil];
    
    return [self breadthSearchFrom:startPos To:end] && [self breadthSearchFrom:startNeg To:end];
}

-(BOOL) breadthSearchFrom:(NSArray*)start To:(NSArray*)end
{
    
    // reset visited table
    for (int i = 0; i < self.numRows; ++i) {
        for (int j = 0; j < self.numCols; ++j) {
            _visited[i][j] = [NSNumber numberWithInt:0];
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
        [[[_visited objectAtIndex:row]objectAtIndex:col] isEqual:[NSNumber numberWithInt:1]];
        
        // check for target
        if (row == targetRow && col == targetCol) {
            return YES;
        }
        // check left neighbor
        if ([_grid[2*row][2*col-1] isEqual:@"-"] && [[[_visited objectAtIndex:row]objectAtIndex:col-1] isEqual:[NSNumber numberWithInt:0]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:col-1], nil]];
            _visited[row][col-1] = [NSNumber numberWithInt:1];
        }
        // check right neighbor
        if ([_grid[2*row][2*col+1] isEqual:@"-"] && [[[_visited objectAtIndex:row]objectAtIndex:col+1] isEqual:[NSNumber numberWithInt:0]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:col+1], nil]];
            _visited[row][col+1] = [NSNumber numberWithInt:1];
        }
        // check above neighbor
        if ([_grid[2*row-1][2*col] isEqual:@"|"] && [[[_visited objectAtIndex:row-1]objectAtIndex:col] isEqual:[NSNumber numberWithInt:0]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row-1], [NSNumber numberWithInt:col], nil]];
            _visited[row-1][col] = [NSNumber numberWithInt:1];
        }
        // check below neighbor
        if ([_grid[2*row+1][2*col] isEqual:@"|"] && [[[_visited objectAtIndex:row+1]objectAtIndex:col] isEqual:[NSNumber numberWithInt:0]]) {
            [connectionQueue addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:row+1], [NSNumber numberWithInt:col], nil]];
            _visited[row+1][col] = [NSNumber numberWithInt:1];
        }
    }
    
    return NO;
}

-(BOOL) connected
{

    return [self checkForComplete];
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
