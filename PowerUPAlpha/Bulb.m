//
//  Bulb.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Bulb.h"

@implementation Bulb


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.image = [UIImage imageNamed:@"bulb_normal"];
    return self;
}

- (void) lightUp
{
    self.image = [UIImage imageNamed:@"bulb_light"];
}

@end
