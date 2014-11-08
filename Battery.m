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
    UIButton* _battery;
}

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*) name
{
    self = [super initWithFrame:frame];
    _name = name;

    CGRect battFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _battery = [[UIButton alloc] initWithFrame:battFrame];
    [_battery setBackgroundImage:[UIImage imageNamed:_name] forState:UIControlStateNormal];
    [_battery addTarget:self.delegate action:@selector(powerUp:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_battery];
    
    return self;
}

- (void) turnedOff
{
    [_battery setBackgroundImage:[UIImage imageNamed:_name] forState:UIControlStateNormal];
}

- (void) turnedOn
{
    NSString* newName = [NSString stringWithFormat:@"%@%@", _name, @"on"];
    [_battery setBackgroundImage:[UIImage imageNamed:newName] forState:UIControlStateNormal];
}

- (void) exploded
{
    NSString* newName = [NSString stringWithFormat:@"%@%@", _name, @"short"];
    [_battery setBackgroundImage:[UIImage imageNamed:newName] forState:UIControlStateNormal];
}

@end
