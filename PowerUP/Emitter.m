//
//  Emitter.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014年 CS121F14S4_Team8. All rights reserved.
//

#import "Emitter.h"

@implementation Emitter
{
    NSString *name;
    NSString *onName;
    //BOOL on;
}

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    //keeps two names for the component, one for On state, one for Off state
    name = imageName;
    onName = [name stringByAppendingString:@"on"];
    self.image = [UIImage imageNamed:name];
    // on = NO;
    return self;
}
//with turnOn and turnOff, simply reset the names
- (void) turnOn
{
    //if(!on){
    [self setImage:[UIImage imageNamed:onName]];
    //on = YES;
    //}
}

- (void) turnOff
{
    //if(on){
    [self setImage:[UIImage imageNamed:name]];
    // on = NO;
    //}
}


@end
