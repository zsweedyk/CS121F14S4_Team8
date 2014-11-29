//
//  MenuViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"
#import "LevelViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MenuViewController (){
    // sounds
    AVAudioPlayer* _audioPlayerLanguagePressed;
    AVAudioPlayer* _audioPlayerAboutPressed;
    AVAudioPlayer* _audioPlayerLevelPressed;
    
    // language control and buttons
    UIButton* _level;
    UIButton* _about;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // set up sounds, segmented control, and buttons
    [self setUpSounds];
    [self setUpButtons];
}

- (void) setUpSounds
{
    NSString *languagePath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *languagePathURL = [NSURL fileURLWithPath : languagePath];
    _audioPlayerLanguagePressed = [[AVAudioPlayer alloc] initWithContentsOfURL:languagePathURL error:nil];
    
    _audioPlayerAboutPressed = _audioPlayerLanguagePressed;
    
    _audioPlayerLevelPressed = _audioPlayerAboutPressed;
}

- (void) setUpButtons
{
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat buttonWidth = frameWidth / 2;
    CGFloat buttonHeight = buttonWidth / 3;
   
    // set up tint color
    UIColor* tintColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    
    // level button set up
    CGRect levelFrame = CGRectMake((frameWidth - buttonWidth) / 2, (frameHeight - buttonHeight) / 2, buttonWidth, buttonHeight);
    _level = [[UIButton alloc] initWithFrame:levelFrame];

    [_level setTitle:NSLocalizedString(@"New Game", nil) forState:UIControlStateNormal];
    [_level setBackgroundColor:[UIColor clearColor]];
    [_level setTitleColor:tintColor forState:UIControlStateNormal];
    [_level addTarget:self action:@selector(chooseLevel:) forControlEvents:UIControlEventTouchUpInside];
    
    // about button set up
    CGRect aboutFrame = CGRectMake((frameWidth - buttonWidth) / 2, (frameHeight + buttonHeight * 2) / 2, buttonWidth, buttonHeight);
    _about = [[UIButton alloc] initWithFrame:aboutFrame];
    
    [_about setTitle:NSLocalizedString(@"Instructions Title", nil) forState:UIControlStateNormal];
    [_about setBackgroundColor:[UIColor clearColor]];
    [_about setTitleColor:tintColor forState:UIControlStateNormal];
    [_about addTarget:self action:@selector(displayHelpMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_level];
    [self.view addSubview:_about];
}

/*
 *  If a level button is pressed, segue to levelviewcontroller
 */
- (void)chooseLevel:(id)sender
{
    [_audioPlayerLevelPressed prepareToPlay];
    [_audioPlayerLevelPressed play];
    
    [self performSegueWithIdentifier:@"PresentLevels" sender:self];
}

/*
 *  Display help message according to the language selected
 */
- (void)displayHelpMessage:(id) sender{
    [_audioPlayerAboutPressed prepareToPlay];
    [_audioPlayerAboutPressed play];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Instructions Title", nil)
                                                        message:NSLocalizedString(@"Instructions", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    
    [alertView show];
}

/*
 *  Pass data to level viewcontroller
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end