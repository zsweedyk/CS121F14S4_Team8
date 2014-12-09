//
//  Wire.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Wire.h"
#import <UIKit/UIKit.h>

@interface Wire () {

}

@end

@implementation Wire

-(id) initWithFrame:(CGRect)frame andConnections:(NSString*)connections
{
    self = [super initWithFrame:frame];
    self.imageName = [NSString stringWithFormat:@"wire%@", connections];
    
    [self displayImage];
    
    return self;
}

@end
