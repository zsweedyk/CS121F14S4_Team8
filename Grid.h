//
//  Grid.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Switch.h"
#import "Battery.h"

@protocol GridDelegate

@required

- (void) componentSelectedAtPosition:(NSNumber*)position WithConnections:(NSString*)newConnection;
- (void) componentAdjustedAtPosition:(NSNumber*)position WithConnections:(NSString*)newConnection;
- (void) masterPowerSelected;

@end


@interface Grid : UIView <SwitchDelegate,BatteryDelegate>

extern const int POSITION_DECODER = 100;

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols;

- (void) clearGrid;
- (void) clearGridExceptAtRow:(int)row andCol:(int)col;
- (void) setUpGrid;
- (void)setValueAtRow:(int)row Col:(int)col To:(enum COMPONENTS)componentType WithDirection:(enum DIRECTION)dir AndConnections:(NSString*)connections;
- (void) turnOnAtRow:(int)row AndCol:(int)col;
- (CGFloat) getCellSize;
- (void) resetLasers;
//- (void) componentsTurnedOff;

@end
