//
//  GameModel.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

@property (nonatomic) int numRows;
@property (nonatomic) int numCols;

-(id) init;
-(void) generateGrid: (NSInteger) level;
-(NSString*) getTypeAtRow: (int) row andCol: (int) col;
-(void) switchSelectedAtRow:(int)row andCol:(int)col withOrientation:(NSString*)newOrientation;
-(BOOL) connected;


@end
