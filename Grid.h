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
- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation;
- (void) deflectorSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation;
- (void) powerOn;
@end


@interface Grid : SKView <SwitchDelegate,BatteryDelegate>

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols;
- (void) setUpGrid;
- (void) setValueAtRow:(int) row col:(int)col to:(NSString*) value;
- (void) bulbConnectedWithIndices: (NSArray*) bulbs;
- (void) shorted;
- (void) emit:(NSArray *)locs;
- (void) setStateWithArray:(NSArray *)locs;

@end
