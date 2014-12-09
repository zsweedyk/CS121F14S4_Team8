//
//  Battery.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Component.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@protocol BatteryDelegate
@required

- (void) powerUp:(id)sender;

@end

@interface Battery: Component

@property (nonatomic, strong) id delegate;

<<<<<<< HEAD
- (id) initWithFrame:(CGRect)frame AtRow:(int)initRow AndCol:(int)initCol AndPolarity:(BOOL)pos WithConnections:(NSString*)connections;

- (int) getPosition;
=======
- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*) name AtRow:(int)row AndCol:(int)col;
- (void) turnedOff;
- (void) turnedOn;
- (void) exploded;
- (int) getRow;
- (int) getCol;
>>>>>>> PowerUP

@end

