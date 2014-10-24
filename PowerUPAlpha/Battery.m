//
//  Battery.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/23/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Battery.h"

@implementation Battery

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*) name
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self addTarget:self.delegate action:@selector(powerUp:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void) turnOnPower
{
    // TODO: change background image
}

@end
