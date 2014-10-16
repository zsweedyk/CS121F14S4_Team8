//
//  GridModel.h
//  Display Prototype
//
//  Created by Daniel Cogan on 10/12/14.
//  Copyright (c) 2014 Team8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridModel : NSObject

-(void) printGrid;
-(void) generateGrid;
-(NSString*) getTypeAtRow: (int) row andCol: (int) col;
-(NSString*) getConnectionsAtRow: (int) row andCol: (int) col;
-(BOOL) findTargetFromRow: (NSInteger) row andCol: (NSInteger) col toType: (NSString*) type;
-(void) setValueAtRow: (int) row andCol: (int) col withValue: (NSString*) value;
//-(NSString*) findPathFrom: (NSString*) path toType: (NSString*) type;

@end
