//
//  MenuViewController.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Enums.h"
#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (nonatomic, assign) enum LANGUAGES mainLanguage;
@property (nonatomic, assign) enum GAME_STATES currentState;
@property (nonatomic, strong) NSMutableArray *locks;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@end

