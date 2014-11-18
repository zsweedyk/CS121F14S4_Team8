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
<<<<<<< HEAD
- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation;
- (void) deflectorSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation;
- (void) masterPowerTurnedOn;
=======
- (void) componentSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation;
- (void) powerOn;
>>>>>>> PowerUp_architecturalChanges
@end


@interface Grid : UIView <SwitchDelegate,BatteryDelegate>

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols;
- (void) setUpGrid;
- (void) setValueAtRow:(int) row col:(int)col to:(NSString*) value;
- (void) shorted;
<<<<<<< HEAD
- (void) emit:(NSArray *)locs;
- (void) setStateWithArray:(NSArray *)locs;
- (void) batteryTurnedOff;
- (void) bulbTurnedOff;
- (int) getBatteryX;
- (int) getBatteryY;
- (int) getBombXWithIndex: (int) i;
- (int) getBombYWithIndex: (int) i;
=======
- (void) setStateAtRow:(int)row AndCol:(int)col to:(BOOL)state;
- (void) resetLasers;
>>>>>>> PowerUp_architecturalChanges

@end
