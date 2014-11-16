//
//  LevelViewController.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelViewController : UIViewController

- (id) initWithLanguage: (int) language;
- (void) unlockLevelWithIndices: (NSMutableArray*) lock;

@end
