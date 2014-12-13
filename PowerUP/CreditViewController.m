//
//  CreditViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 12/9/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "CreditViewController.h"
#import "MenuViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CreditViewController (){
    IBOutlet UIImageView* _background;
    AVAudioPlayer *_audioPlayerBackPressed;
}

@end

@implementation CreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSounds];
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

- (void) setUpSounds
{
    NSString *backPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *backPathURL  = [NSURL fileURLWithPath : backPath];
    _audioPlayerBackPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:backPathURL error:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_audioPlayerBackPressed prepareToPlay];
    [_audioPlayerBackPressed play];
    
    if ([segue.identifier isEqualToString:@"CreditToMenu"]) {
        MenuViewController *destViewController = [segue destinationViewController];
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
    }
}

@end
