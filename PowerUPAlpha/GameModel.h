//
//  GameModel.h
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

-(void) printGrid;
-(void) generateGrid;
-(NSString*) getTypeAtRow: (int) row andCol: (int) col;
-(NSString*) getConnectionsAtRow: (int) row andCol: (int) col;
-(BOOL) findTargetFromRow: (NSInteger) row andCol: (NSInteger) col toType: (NSString*) type;
-(void) setValueAtRow: (int) row andCol: (int) col withValue: (NSString*) value;

@end
