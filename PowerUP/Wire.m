//
//  Wire.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Wire.h"
#import <UIKit/UIKit.h>

@implementation Wire

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    self.image = [UIImage imageNamed:imageName];
    return self;
}

@end
