//
//  Receiver.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Receiver.h"

@implementation Receiver

<<<<<<< HEAD
#pragma mark - Initialization

- (id) initWithFrame:(CGRect)frame Direction:(enum DIRECTION)dir andConnections:(NSString*)connections {
    
    self = [super initWithFrame:frame];
    
    [self setUpImageNameWithDirection:dir AndConnections:connections];
    
    [self displayImage];
    return self;
}

#pragma mark - Private Methods

- (void) setUpImageNameWithDirection:(enum DIRECTION)dir AndConnections:(NSString*)connections {
=======
- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName
{
    self       = [super initWithFrame:frame];
    name       = imageName;
    self.image = [UIImage imageNamed:name];
    return self;
}

- (void) turnOn
{
    NSString *onName = [name stringByAppendingString:@"on"];
>>>>>>> PowerUP
    
    NSString* direction = [self getDirectionString:dir];
    
    self.imageName = [NSString stringWithFormat:@"receiver%@%@", direction, connections];
}


@end
