//
//  MenuViewController.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet
UISegmentedControl* segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton* about;
@property (weak, nonatomic) IBOutlet UIButton* level;

- (IBAction)indexChanged:(UISegmentedControl *)sender;
- (IBAction)displayHelpMessage:(UIButton*) sender;

@end

