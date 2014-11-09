//
//  Receiver.h
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014年 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Receiver : UIImageView

-(id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName;
-(void) turnOn;
- (void) turnOff;

@end
