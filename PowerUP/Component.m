//
//  Component.m
//  PowerUP
//
//  Created by Sean on 12/7/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Component.h"

@interface Component () {
    BOOL on;
}

@end

@implementation Component

const int CONNECTION_STRING_LENGTH = 4;
const int STATE_STRING_LENGTH = 2;

#pragma mark - Initialization

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    on = NO;
    
    return self;
}

#pragma mark - Public Method

- (void) displayImage {
    CGRect viewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.image = [[UIImageView alloc] initWithFrame:viewFrame];
    self.image.image = [UIImage imageNamed:self.imageName];
    
    [self addSubview:self.image];
}

- (NSString*) getDirectionString:(enum DIRECTION)dir {
    
    NSString* direction;
    switch (dir) {
        case LEFT:
            direction = @"Left";
            break;
        case RIGHT:
            direction = @"Right";
            break;
        case TOP:
            direction = @"Top";
            break;
        case BOTTOM:
            direction = @"Bottom";
            break;
        default:
            break;
    }
    
    return direction;
}

- (NSString*) getConnections {
    if (on) {
        return [self.imageName substringWithRange:NSMakeRange(self.imageName.length - CONNECTION_STRING_LENGTH - STATE_STRING_LENGTH, CONNECTION_STRING_LENGTH)];
    } else {
        return [self.imageName substringFromIndex:(self.imageName.length - CONNECTION_STRING_LENGTH)];
    }
}

- (void) turnOn {
    self.imageName = [self.imageName stringByAppendingString:@"on"];
    [self displayImage];
    on = YES;
}

- (void) turnOff {
    if (on) {
        self.imageName = [self.imageName substringToIndex:(self.imageName.length-2)];
        on = NO;
    }
}

@end
