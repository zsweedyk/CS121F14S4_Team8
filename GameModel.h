//
//  GameModel.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLaserModel.h"

@interface GameModel : NSObject

- (id) initWithTotalLevels: (int) levels;
- (void) generateGrid: (int) level;

- (enum COMPONENTS) getTypeAtRow: (int) row andCol: (int) col;
- (enum DIRECTION) getDirectionAtRow:(int)row andCol:(int)col;
- (NSString*) getConnectionAtRow:(int)row andCol:(int)col;
- (BOOL) getStateAtRow:(int)row andCol:(int)col;
- (void) componentSelectedAtRow:(int)row andCol:(int)col WithConnections:(NSString*)newConnections;

- (NSArray*) getLasers;
- (NSArray*) getBatteries;
- (NSArray*) getConnectedBombs;
- (void) updateGameStatus;

@property BOOL complete;
@property BOOL shorted;
@property BOOL exploded;
@property int rows;
@property int cols;

@end
