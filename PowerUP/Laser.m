//
//  Laser.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Laser.h"

@implementation Laser

#pragma mark - Initialization

-(id) initWithFrame:(CGRect)frame WithConnections:(NSString*)connections {
    self = [super initWithFrame:frame];
    
    [self setUpImageNameWithConnections:connections];
    
    [self displayImage];
    return self;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void) setUpImageNameWithConnections:(NSString*)connections {
    self.imageName = [NSString stringWithFormat:@"laser%@",connections];
}

@end
