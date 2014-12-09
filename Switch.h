//
//  Switch.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Enums.h"
#import "Component.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SwitchDelegate
@required

- (void) switchChangedAtPosition:(NSNumber*)position WithConnections:(NSString*)connections;

@end

@interface Switch : Component

@property (nonatomic, strong) id delegate;
@property enum TOUCH_STATE touchState;
@property enum DIRECTION touchEnteredDir;
@property enum DIRECTION touchExitedDir;

- (id) initWithFrame:(CGRect)frame AtRow:(int)initRow AndCol:(int)initCol WithConnections:(NSString*)connections;
- (void) addEnteredDirection;
- (void) addExitedDirection;
- (void) tempAddEnteredDirection;
- (void) tempAddExitedDirection;
- (void) tempRemoveEnteredDirection;
- (void) tempRemoveExitedDirection;
- (void) resetDirection;
- (int) getPosition;

@end
