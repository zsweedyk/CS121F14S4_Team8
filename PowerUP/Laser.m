//
//  Laser.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014年 CS121F14S4_Team8. All rights reserved.
//

#import "Laser.h"

@implementation Laser

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    self.image = [UIImage imageNamed:imageName];
    return self;
}

@end
