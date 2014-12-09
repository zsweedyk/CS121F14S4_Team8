//
//  BombModel.h
//  PowerUP
//
//  Created by Sean on 12/6/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "ComponentModel.h"

@interface BombModel : ComponentModel

- (id) initType:(enum COMPONENTS)newType AtRow:(int)row AndCol:(int)col WithState:(BOOL)state;

@end
