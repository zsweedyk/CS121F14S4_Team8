//
//  InstructionsViewController.h
//  PowerUP
//
//  Created by Daniel Cogan on 12/8/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController

@property (nonatomic, assign) enum GAME_STATES currentState;
@property (nonatomic, assign) enum LANGUAGES mainLanguage;
@property (nonatomic, assign) NSInteger gameLevel;
@property (nonatomic, assign) NSInteger totalLevel;
@property (nonatomic, strong) NSMutableArray *locks;

@end
