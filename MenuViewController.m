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
#import "CreditViewController.h"
#import "InstructionsViewController.h"
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
    
    IBOutlet UILabel* _playLabel;
    IBOutlet UILabel* _helpLabel;
    IBOutlet UILabel* _aboutLabel;
    IBOutlet UILabel* _settingsLabel;
    
    NSDictionary* menuText;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpDictionary];
    // set up sounds and labels
    [self setUpSounds];
    [self setUpLabels];
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


-(void) setUpLabels {
    _playLabel.text = [menuText objectForKey:@"levelTitle"];
    _helpLabel.text = [menuText objectForKey:@"helpTitle"];
    _aboutLabel.text = [menuText objectForKey:@"aboutTitle"];
    _settingsLabel.text = [menuText objectForKey:@"settingsTitle"];
}

/*
 *  change the background if button is pressed
 */
- (IBAction) setBG0
{
    self.background.image = [UIImage imageNamed:@"BGmain.png"];
    _playLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:0.4];
    _helpLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:0.4];
    _aboutLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:0.4];
    _settingsLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:0.4];
}
- (IBAction) setBG1
{
    self.background.image = [UIImage imageNamed:@"BGmain1.png"];
    _playLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:1];
}
- (IBAction) setBG2
{
    self.background.image = [UIImage imageNamed:@"BGmain2.png"];
    _helpLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:1];
}
- (IBAction) setBG3
{
    self.background.image = [UIImage imageNamed:@"BGmain3.png"];
    _aboutLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:1];
}
- (IBAction) setBG4
{
    self.background.image = [UIImage imageNamed:@"BGmain4.png"];
    _settingsLabel.textColor = [UIColor colorWithRed:(2/255.0) green:(243/255.0) blue:1 alpha:1];
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
    
    if ([segue.identifier isEqualToString:@"PresentInstructions"]) {
        InstructionsViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
    }
    
    if ([segue.identifier isEqualToString:@"GameToCredit"]) {
        CreditViewController *destViewController = segue.destinationViewController;
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