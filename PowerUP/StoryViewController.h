//
//  StoryViewController.h
//  PowerUP
//
//  Created by Sean on 12/1/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Enums.h"
#import <UIKit/UIKit.h>

@interface StoryViewController : UIViewController

@property (nonatomic, assign) enum GAME_STATES currentState;
@property (nonatomic, assign) enum LANGUAGES mainLanguage;
@property (nonatomic, assign) NSInteger gameLevel;
@property (nonatomic, assign) NSInteger totalLevel;
@property (nonatomic, strong) NSMutableArray *locks;

+ (BOOL) needToDisplayStoryAtLevel:(int)level andState:(int)state;

@end
