//
//  GameViewController.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Enums.h"
#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, assign) enum LANGUAGES mainLanguage;
@property (nonatomic, assign) enum GAME_STATES currentState;
@property (nonatomic, assign) NSInteger gameLevel;
@property (nonatomic, assign) NSInteger totalLevel;
@property (nonatomic, strong) NSMutableArray *locks;

@end
