//
//  LaserModel.h
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-22.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentModel.h"

@interface GameLaserModel : NSObject

@property NSMutableArray* lasers;
@property NSMutableArray* emitters;
@property NSMutableArray* deflectors;
@property NSMutableArray* receivers;

- (id) initWithGrid:(NSArray*)grid numRow:(int)row numCol:(int)col;

- (void) clearLasers;
//- (NSArray*) getReceivers;
- (void) addComponent:(ComponentModel*)component;
- (BOOL) didEmitterStateChange:(NSArray*)states;
- (void) updateLasers;
- (void) resetComponents;
- (void) clearLaserComponents;

@end
