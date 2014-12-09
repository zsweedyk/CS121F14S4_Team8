//
//  Receiver.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Receiver.h"

@implementation Receiver

#pragma mark - Initialization

- (id) initWithFrame:(CGRect)frame Direction:(enum DIRECTION)dir andConnections:(NSString*)connections {
    
    self = [super initWithFrame:frame];
    
    [self setUpImageNameWithDirection:dir AndConnections:connections];
    
    [self displayImage];
    return self;
}

#pragma mark - Private Methods

- (void) setUpImageNameWithDirection:(enum DIRECTION)dir AndConnections:(NSString*)connections {
    
    NSString* direction = [self getDirectionString:dir];
    
    self.imageName = [NSString stringWithFormat:@"receiver%@%@", direction, connections];
}


@end
