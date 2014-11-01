//
//  GameViewController.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UIAlertViewDelegate>

- (id) initWithLevel: (int) startLevel AndTotalLevels: (int) totalLevels AndLanguage: (int) language;

@end
