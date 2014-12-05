//
//  MenuViewController.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
{
    
    IBOutlet UIImageView* backgroundImage;
    IBOutlet UIButton* playButton;
    IBOutlet UIButton* helpButton;
    IBOutlet UIButton* aboutButton;
    IBOutlet UIButton* settingsButton;
    
}



@property (nonatomic, assign) NSInteger mainLanguage;

@end

