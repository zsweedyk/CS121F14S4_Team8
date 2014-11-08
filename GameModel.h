//
//  GameModel.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

-(id) initWithTotalLevels: (int) levels;
-(void) generateGrid: (int) level;
-(NSString*) getTypeAtRow: (int) row andCol: (int) col;
-(void) switchSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation;
-(BOOL) connected;
-(BOOL) shorted;

- (int) getNumRows;
- (int) getNumCols;

@end
