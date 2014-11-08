//
//  Grid.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Switch.h"
#import "Battery.h"

@protocol GridDelegate

@required
- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation;
- (void) powerOn;
@end


@interface Grid : UIView <SwitchDelegate,BatteryDelegate>

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols;
- (void) setUpGridForNumRows:(int)rows andCols:(int)cols;
- (void) setValueAtRow:(int) row col:(int)col to:(NSString*) value;
- (void) win;
- (void) shorted;

@end
