//
//  Receiver.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Receiver.h"

@implementation Receiver
{
    NSString *name;
}

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
    
    [self setImage:[UIImage imageNamed:onName]];
}

- (void) turnOff
{
    [self setImage:[UIImage imageNamed:name]];
}

@end
