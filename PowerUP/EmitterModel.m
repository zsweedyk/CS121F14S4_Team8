//
//  EmitterModel.m
//  PowerUP
//
//  Created by Sean on 12/6/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "EmitterModel.h"

@implementation EmitterModel

- (id) initType:(enum COMPONENTS)newType AtRow:(int)row AndCol:(int)col WithState:(BOOL)state AndDirection:(enum DIRECTION)direction {
    
    self = [super initType:newType AtRow:row AndCol:col WithState:state];
    
    self.direction = direction;
    
    return self;
}

@end
