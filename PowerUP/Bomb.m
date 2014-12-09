//
//  Bomb.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/28/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb

#pragma mark - Initialization

- (id) initWithFrame:(CGRect)frame WithConnections:(NSString*)connections {
    
    self = [super initWithFrame:frame];
    
    [self setUpImageNameWithConnections:connections];
    
    [self displayImage];
    
    return self;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void) setUpImageNameWithConnections:(NSString*)connections {
    self.imageName = [NSString stringWithFormat:@"bomb%@", connections];
}


@end
