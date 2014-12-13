//
//  CreditViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 12/9/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "CreditViewController.h"
#import "MenuViewController.h"

@interface CreditViewController (){
    IBOutlet UIImageView* _background;
}

@end

@implementation CreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    // Do any additional setup after loading the view.
}

- (void) setBackground
{
    switch (self.mainLanguage) {
        case ENGLISH:
            [_background setImage:[UIImage imageNamed:@"BGabout.png"]];
            break;
            
        case SPANISH:
            [_background setImage:[UIImage imageNamed:@"BGaboutSP.png"]];
            break;
            
        case CHINESE:
            [_background setImage:[UIImage imageNamed:@"BGaboutCH.png"]];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CreditToMenu"]) {
        MenuViewController *destViewController = [segue destinationViewController];
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
