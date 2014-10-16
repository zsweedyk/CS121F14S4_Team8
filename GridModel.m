//
//  GridModel.m
//  Display Prototype
//
//  Created by Daniel Cogan on 10/12/14.
//  Copyright (c) 2014 Team8. All rights reserved.
//

#import "GridModel.h"

@interface GridModel()
{
    NSString* _grid[19][29];
    NSInteger _visited[19][29]; // table for BFS
    
}
@end

@implementation GridModel

//nothing=0
//wire = 1
//battery+=2
//battery-=3,6
//lightbulb=4
//bulbconnection=5


-(void) generateGrid
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test0" ofType:@""];
    NSError* error;
    
    // Read grids from text file
    for (int r=0; r<19; r++) {

        NSString* readString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        NSRange range = NSMakeRange(r*31, 29);
        NSString* gridString = [readString substringWithRange:range];
        for (int c = 0; c<29; c++) {
            _grid[r][c] = [gridString substringWithRange:NSMakeRange(c, 1)];
            _grid[r][c] = [gridString substringWithRange:NSMakeRange(c, 1)];
        }
    }
    
    [self printGrid];
}

-(NSString*) getTypeAtRow: (int) row andCol: (int) col
{
    return _grid[2*row][2*col];
}

-(void) setValueAtRow: (int) row andCol: (int) col withValue: (NSString*) value
{
    _grid[row][col] = value;
}

-(NSString*) getConnectionsAtRow: (int) row andCol: (int) col
{
    NSString* connections = @"";
    
    if ([_grid[2*row][2*col-1]  isEqual: @"-"]) {
        connections = [connections stringByAppendingString:@"L"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if ([_grid[2*row][2*col+1]  isEqual: @"-"]) {
        connections = [connections stringByAppendingString:@"R"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if ([_grid[2*row-1][2*col]  isEqual: @"|"]) {
        connections = [connections stringByAppendingString:@"T"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if ([_grid[2*row+1][2*col]  isEqual: @"|"]) {
        connections = [connections stringByAppendingString:@"B"];
    }else{
        connections = [connections stringByAppendingString:@"X"];
    }

    return connections;
}


-(BOOL) findTargetFromRow: (NSInteger) row andCol: (NSInteger) col toType: (NSString*) type
{
    // reset visited table
    for (NSInteger i = 0; i<19; i++)
    {
        for (NSInteger j = 0; j < 29; j++) {
            _visited[i][j] = 0;
        }
    }
    
    // add start grid to visited table
    _visited[row][col] = 1;
    
    // initialize a queue for BFS and add current grid to the que
    NSMutableArray* queue = [[NSMutableArray alloc] init];
    NSArray* initPos = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:row],[NSNumber numberWithInt:col], nil];
    [queue addObject:initPos];
    
    // BFS
    while ([queue count] > 0)
    {
        NSArray* position = queue[0];
        [queue removeObjectAtIndex:0];
        
        NSInteger r = [position[0] integerValue];
        NSInteger c = [position[1] integerValue];
        
        // check if left neighbor is the goal, if not, add to the queue
        if ([_grid[r][c-1]  isEqual: @"-"] && _visited[r][c-2] == 0) {
            if ([_grid[r][c-2]  isEqual: type])
                return YES;

            if ([_grid[r][c-2]  isEqual: @"1"])
            {
                _visited[r][c - 2] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r],[NSNumber numberWithInt:(c-2)], nil]];
            }
        }
        
        // check if right neighbor is the goal, if not, add to the queue
        if ([_grid[r][c+1]  isEqual: @"-"] && _visited[r][c+2] == 0) {
            if ([_grid[r][c+2]  isEqual: type])
                return YES;
            
            if ([_grid[r][c+2]  isEqual: @"1"])
            {
                _visited[r][c + 2] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r],[NSNumber numberWithInt:(c+2)], nil]];
            }
        }
        
        // check if top neighbor is the goal, if not, add to the queue
        if ([_grid[r-1][c]  isEqual: @"|"] && _visited[r-2][c] == 0) {
            if ([_grid[r-2][c]  isEqual: type])
                return YES;
            
            if ([_grid[r-2][c]  isEqual: @"1"])
            {
                _visited[r-2][c] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r-2],[NSNumber numberWithInt:(c)], nil]];
            }
        }
        
        // check if bottom neighbor is the goal, if not, add to the queue
        if ([_grid[r+1][c]  isEqual: @"|"] && _visited[r+2][c] == 0) {
            if ([_grid[r+2][c]  isEqual: type])
                return YES;
            
            if ([_grid[r+2][c]  isEqual: @"1"])
            {
                _visited[r+2][c] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r+2],[NSNumber numberWithInt:(c)], nil]];
            }
        }
    }
    
    // nothing is found
    return NO;
}


-(BOOL) string: (NSString*) string contains: (NSString*) sub
{
    return !([string rangeOfString:sub].location == NSNotFound);
}

-(int) numOf: (NSString*) str in: (NSString*) sub
{
    int count = 0;
    NSUInteger length = [str length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [str rangeOfString: sub options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    return count;
}



-(void) printGrid
{
    for(int r = 0;r<19;r++)
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
