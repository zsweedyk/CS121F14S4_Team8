//
//  Receiver.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014年 CS121F14S4_Team8. All rights reserved.
//

#import "Receiver.h"

@implementation Receiver
{
    NSString *name;
    NSString *onName;
}

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    name = imageName;
    onName = [imageName stringByAppendingString:@"on"];
    self.image = [UIImage imageNamed:name];
    return self;
}

- (void) turnOn
{
    [self setImage:[UIImage imageNamed:onName]];
}

- (void) turnOff
{
    [self setImage:[UIImage imageNamed:name]];
}

@end
