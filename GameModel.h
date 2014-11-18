//
//  GameModel.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

<<<<<<< HEAD
-(id) initWithTotalLevels: (int) levels;
-(void) generateGrid: (int) level;
-(NSString*) getTypeAtRow: (int) row andCol: (int) col;
-(void) switchSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation;
-(void) deflectorSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation;
-(void) checkEmitterConnection;
-(BOOL) connected;
-(BOOL) shorted;

-(NSArray*) connectedBombs;
-(NSArray *) bulbIndices;
-(NSArray *) getLaserPath;
-(NSArray *)emitters;
-(NSArray *)deflectors;
-(NSArray *)receivers;
=======
- (id) initWithTotalLevels: (int) levels;
- (void) generateGrid: (int) level;
- (NSString*) getTypeAtRow: (int) row andCol: (int) col;
- (void) componentSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation;
- (BOOL) isConnected;
- (BOOL) isShorted;
- (void) powerOn;

- (NSArray*) getConnectedBulbs;
- (NSArray*) getLasers;
- (NSArray*) getConnectedEmitters;
- (NSArray*) getConnectedDeflectors;
- (NSArray*) getConnectedReceivers;
>>>>>>> PowerUp_architecturalChanges

- (int) getNumRows;
- (int) getNumCols;

@end
