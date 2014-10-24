//
//  Battery.h
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/23/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BatteryDelegate
@required
- (void) powerUp:(id)sender;
@end

@interface Battery: UIButton

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*) name;
- (void) turnOnPower;

@end

