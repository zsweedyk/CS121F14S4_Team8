//
//  Bulb.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Bulb.h"

@implementation Bulb


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.image = [UIImage imageNamed:@"bulb"];
    return self;
}

- (void) turnOn
{
    self.image = [UIImage imageNamed:@"bulbon"];
}

- (void) turnOff
{
    self.image = [UIImage imageNamed:@"bulb"];
}


@end
