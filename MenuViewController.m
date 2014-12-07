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
#import "StoryViewController.h"
#import "SettingsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MenuViewController (){
    // sounds
    AVAudioPlayer *_audioPlayerLanguagePressed;
    AVAudioPlayer *_audioPlayerAboutPressed;
    AVAudioPlayer *_audioPlayerLevelPressed;
    
    // language control and buttons
    UISegmentedControl* _segmentControl;
    UIButton* _level;
    UIButton* _about;
    
    NSDictionary* menuText;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpDictionary];
    // set up sounds, segmented control, and buttons
    [self setUpSounds];
}

- (void) setUpSounds
{
    NSString *languagePath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *languagePathURL = [NSURL fileURLWithPath : languagePath];
    _audioPlayerLanguagePressed = [[AVAudioPlayer alloc] initWithContentsOfURL:languagePathURL error:nil];
    
    _audioPlayerAboutPressed = _audioPlayerLanguagePressed;
    
    _audioPlayerLevelPressed = _audioPlayerAboutPressed;
}

- (void) setUpDictionary {
    NSString *plistPath;
    switch (self.mainLanguage) {
        case ENGLISH:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"MenuText" ofType:@"plist"];
            break;
            
        case SPANISH:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"MenuTextSpanish" ofType:@"plist"];
            break;
            
        case CHINESE:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"MenuTextChinese" ofType:@"plist"];
            break;
            
        default:
            break;
    }
    
    menuText = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

/*
 *  change the background if button is pressed
 */
- (IBAction) setBG0
{
    self.background.image = [UIImage imageNamed:@"BGmain.png"];
}
- (IBAction) setBG1
{
    self.background.image = [UIImage imageNamed:@"BGmain1.png"];
}
- (IBAction) setBG2
{
    self.background.image = [UIImage imageNamed:@"BGmain2.png"];
}
- (IBAction) setBG3
{
    self.background.image = [UIImage imageNamed:@"BGmain3.png"];
}
- (IBAction) setBG4
{
    self.background.image = [UIImage imageNamed:@"BGmain4.png"];
}

/*
 *  If a level button is pressed, segue to appropriate view controller
 */
- (IBAction) chooseLevel:(id)sender
{
    [_audioPlayerLevelPressed prepareToPlay];
    [_audioPlayerLevelPressed play];
    
    if (self.currentState == FIRST_TIME) {
        [self performSegueWithIdentifier:@"PresentStoryView" sender:self];
    } else {
        [self performSegueWithIdentifier:@"PresentLevels" sender:self];
    }
}

/*
 *  Display help message according to the language selected
 */
- (void)displayHelpMessage:(id) sender{
    [_audioPlayerAboutPressed prepareToPlay];
    [_audioPlayerAboutPressed play];
    
    NSString *title = [menuText objectForKey:@"helpTitle"];
    NSString *message = [menuText objectForKey:@"helpMessage"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

/*
 *  Pass data to viewcontrollers
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PresentLevels"]) {
        LevelViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks        = self.locks;
    }
    
    if ([segue.identifier isEqualToString:@"PresentStoryView"]) {
        StoryViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
    }
    
    if ([segue.identifier isEqualToString:@"PresentSettings"]) {
        SettingsViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end