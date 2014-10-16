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
    NSInteger _visited[19][29];
    
}
@end

@implementation GridModel

//nothing=0
//wire = 1
//battery+=2
//battery-=3
//lightbulb=4

-(void) generateGrid
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test0" ofType:@""];
    NSError* error;
    // Read grids from text file
    
    for (int r=0; r<19; r++) {

        NSString* readString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        NSRange range = NSMakeRange(r*31, 29);
        NSString* gridString = [readString substringWithRange:range];
        //printf([gridString UTF8String]);
        for (int c = 0; c<29; c++) {
            _grid[r][c] = [gridString substringWithRange:NSMakeRange(c, 1)];
            _grid[r][c] = [gridString substringWithRange:NSMakeRange(c, 1)];
        }
    }
    
    //[self printGrid];
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
    //printf([connections UTF8String]);
    return connections;
}

-(void) resetVisited: (NSInteger) visited
{
   
}


-(NSInteger) findTargetFromRow: (NSInteger) row andCol: (NSInteger) col toType: (NSString*) type
{
    //printf([_grid[row][col] UTF8String]);
    for (NSInteger i = 0; i<19; i++)
    {
        for (NSInteger j = 0; j < 29; j++) {
            _visited[i][j] = 0;
        }
    }
    
    _visited[row][col] = 1;
    
    NSMutableArray* queue = [[NSMutableArray alloc] init];
    NSArray* initPos = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:row],[NSNumber numberWithInt:col], nil];
    [queue addObject:initPos];
    
    while ([queue count] > 0)
    {
        NSArray* position = queue[0];
        [queue removeObjectAtIndex:0];
        NSInteger r = [position[0] integerValue];
        NSInteger c = [position[1] integerValue];
        NSLog(@"sequence = %i",r);
        NSLog(@"sequence = %i",c);
        //printf([_grid[r][c -1] UTF8String]);
        //printf([_grid[r][c -2] UTF8String]);
        NSLog(@"%i",_visited[r][c - 2]);
        
        if ([_grid[r][c-1]  isEqual: @"-"] && _visited[r][c-2] == 0) {
            if ([_grid[r][c-2]  isEqual: type])
                return 1;

            if ([_grid[r][c-2]  isEqual: @"1"])
            {
                _visited[r][c - 2] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r],[NSNumber numberWithInt:(c-2)], nil]];
            }
        }
        
        if ([_grid[r][c+1]  isEqual: @"-"] && _visited[r][c+2] == 0) {
            if ([_grid[r][c+2]  isEqual: type])
                return 1;
            
            if ([_grid[r][c+2]  isEqual: @"1"])
            {
                _visited[r][c + 2] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r],[NSNumber numberWithInt:(c+2)], nil]];
            }
        }
        
        if ([_grid[r-1][c]  isEqual: @"|"] && _visited[r-2][c] == 0) {
            if ([_grid[r-2][c]  isEqual: type])
                return 1;
            
            if ([_grid[r-2][c]  isEqual: @"1"])
            {
                _visited[r-2][c] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r-2],[NSNumber numberWithInt:(c)], nil]];
            }
        }
        
        if ([_grid[r+1][c]  isEqual: @"|"] && _visited[r+2][c] == 0) {
            if ([_grid[r+2][c]  isEqual: type])
                return 1;
            
            if ([_grid[r+2][c]  isEqual: @"1"])
            {
                _visited[r+2][c] = 1;
                [queue addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:r+2],[NSNumber numberWithInt:(c)], nil]];
            }
        }
    }
    return 0;
}

//-(NSString*) findPathFrom: (NSString*) path toType: (NSString*) type
//{
//    NSString* currentPos = [path substringWithRange:NSMakeRange(path.length-5, 5)];
//    
//    int numCurrent = (int)[[path componentsSeparatedByString:currentPos] count] - 1;
//    
//    //If currentPos is already contained in path,
//    if (numCurrent>1) {
//        return [path substringWithRange:NSMakeRange(0, path.length-5)];
//    }
//    
//    int row = [[path substringWithRange:NSMakeRange(path.length-5, 2)] intValue];
//    int col = [[path substringWithRange:NSMakeRange(path.length-2, 2)] intValue];
//    
//    if (type == [self getTypeAtRow:row andCol:col]) {
//        return path;
//    }
//    
//    NSString* connections = [self getConnectionsAtRow:row andCol:col];
//    if ([self string:connections contains:@"L"]) {
//        NSString* next = [NSString stringWithFormat:@"/%d.%d",row, col];
//        path = [path stringByAppendingString:next];
//        return [self findPathFrom:path toType:<#(NSString *)#>]
//    }
//    
//    
//    NSLog([self getTypeAtRow:row andCol:col]);
//    return [self getTypeAtRow:row andCol:col];
//}



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
