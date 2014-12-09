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

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols;

- (void) clearGrid;
- (void) clearGridExceptAtRow:(int)row andCol:(int)col;
- (void) setUpGrid;
<<<<<<< HEAD
- (void)setValueAtRow:(int)row Col:(int)col To:(enum COMPONENTS)componentType WithDirection:(enum DIRECTION)dir AndConnections:(NSString*)connections;

- (void) turnOnAtRow:(int)row AndCol:(int)col;

//- (void) shorted;
- (int) getBatteryX;
- (int) getBatteryY;
- (int) getBombXAtRow:(int)row AndCol:(int)col;
- (int) getBombYAtRow:(int)row AndCol:(int)col;
//- (void) setStateAtRow:(int)row AndCol:(int)col to:(BOOL)state;
=======
- (void) setValueAtRow:(int) row col:(int)col to:(NSString*) value;
- (void) shorted;
- (CGFloat) getCellSize;
- (void) setStateAtRow:(int)row AndCol:(int)col to:(BOOL)state;
>>>>>>> PowerUP
- (void) resetLasers;
//- (void) componentsTurnedOff;

@end
