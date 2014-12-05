//
//  SettingsViewController.h
//  PowerUP
//
//  Created by CS121 on 12/5/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (nonatomic, assign) enum LANGUAGES mainLanguage;
@property (nonatomic, strong) NSMutableArray*  locks;

@end
