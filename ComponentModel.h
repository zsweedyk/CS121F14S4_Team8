//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Enums.h"
#import <Foundation/Foundation.h>


@interface ComponentModel : NSObject

- (id) initType:(enum COMPONENTS)type AtRow:(int)row AndCol:(int)col WithState:(BOOL)state;
- (NSString*) getConnections;

@property BOOL connectedRight;
@property BOOL connectedLeft;
@property BOOL connectedTop;
@property BOOL connectedBottom;

@property BOOL state;
@property enum DIRECTION direction;

@property int row;
@property int col;

@property enum COMPONENTS type;

@end