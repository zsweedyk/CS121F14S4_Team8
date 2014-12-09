//
//  Deflector.h
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Component.h"
#import "DirectionController.h"

@protocol DeflectorDelegate
@required

- (void) deflectorSelectedAtPosition:(NSNumber*)position WithConnections:(NSString*)connections;
- (void) deflectorAdjustedAtPosition:(NSNumber*)position ToConnection:(NSString*)connections;

@end
@interface Deflector : Component

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame AtRow:(int)initRow AndCol:(int)initCol WithConnections:(NSString*)connections;

@end