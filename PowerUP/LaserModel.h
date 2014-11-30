//
//  LaserModel.h
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-22.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentModel.h"

@interface LaserModel : NSObject

- (id) initWithGrid:(NSArray*)grid numRow:(int)row numCol:(int)col;
- (NSArray*) getLasers;
- (void) clearLasers;
- (NSArray*) getEmitters;
- (NSArray*) getDeflectors;
- (NSArray*) getReceivers;
- (void) addComponent:(ComponentModel*)component;
- (BOOL) didEmitterStateChange:(NSArray*)states;
- (void) updateLasers;
- (void) resetComponents;
- (void) clearLaserComponents;

@end
