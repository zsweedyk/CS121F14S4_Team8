//
//  Component.h
//  PowerUP
//
//  Created by Sean on 12/7/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Enums.h"
#import <UIKit/UIKit.h>

@interface Component : UIView

@property enum COMPONENTS type;
@property UIImageView *image;
@property NSString *imageName;

- (id) initWithFrame:(CGRect)frame;
- (void) turnOn;
- (void) turnOff;

- (void) displayImage;
- (NSString*) getDirectionString:(enum DIRECTION)dir;
- (NSString*) getConnections;


@end
