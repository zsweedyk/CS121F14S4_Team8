//
//  Battery.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Battery.h"

@implementation Battery{
    NSString* _name;
}

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*) name
{
    self = [super initWithFrame:frame];
    _name = name;
    
    [self setBackgroundImage:[UIImage imageNamed:_name] forState:UIControlStateNormal];
    [self addTarget:self.delegate action:@selector(powerUp:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void) turnedOn
{
    _name = [NSString stringWithFormat:@"%@%@", _name, @"on"];
    [self setBackgroundImage:[UIImage imageNamed:_name] forState:UIControlStateNormal];
}

- (void) exploded
{
    _name = [NSString stringWithFormat:@"%@%@", _name, @"short"];
    [self setBackgroundImage:[UIImage imageNamed:_name] forState:UIControlStateNormal];
}

@end
