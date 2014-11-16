//
//  Bomb.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/28/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName
{
    self = [super initWithFrame:frame];
    self.image = [UIImage imageNamed:imageName];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
