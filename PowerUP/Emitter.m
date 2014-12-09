//
//  Emitter.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Emitter.h"

@implementation Emitter
{
}

#pragma mark - Initialization
- (id) initWithFrame:(CGRect)frame Direction:(enum DIRECTION)dir andConnections:(NSString*)connections
{
    self = [super initWithFrame:frame];
    //keeps two names for the component, one for On state, one for Off state
    
    [self setUpImageNameWithDirection:dir AndConnections:connections];
    
    [self displayImage];
    
    return self;
}

<<<<<<< HEAD
#pragma mark - Private Methods
=======
//with turnOn and turnOff, simply reset the names
- (void) turnOn
{
    NSString *onName = [name stringByAppendingString:@"on"];
    
    [self setImage:[UIImage imageNamed:onName]];
}
>>>>>>> PowerUP

- (void) setUpImageNameWithDirection:(enum DIRECTION)dir AndConnections:(NSString*)connections {
    
    NSString* direction = [self getDirectionString:dir];
    
    self.imageName = [NSString stringWithFormat:@"emitter%@%@", direction, connections];
}


@end
