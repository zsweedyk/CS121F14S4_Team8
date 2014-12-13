//
//  GameModel.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaserModel.h"

@interface GameModel : NSObject

- (id) initWithTotalLevels: (int) levels;
- (void) generateGrid: (int) level;

- (NSString*) getTypeAtRow: (int) row andCol: (int) col;
- (void) componentSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation;

- (NSArray*) getConnectedBombs;
- (NSArray*) getConnectedBulbs;
- (NSArray*) getLasers;
- (NSArray*) getConnectedEmitters;
- (NSArray*) getConnectedDeflectors;
- (NSArray*) getConnectedReceivers;
- (NSArray*) getBatteries;

- (BOOL) isConnected;
- (BOOL) isShorted;
- (BOOL) isBombConnected;
- (void) powerOn;
- (void) powerOff;

- (int) getNumRows;
- (int) getNumCols;

//for testing purposes only
@property (strong,nonatomic) LaserModel *laserModel;

@end
