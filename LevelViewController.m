//
//  LevelViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "LevelViewController.h"
#import "GameViewController.h"
#import "MenuViewController.h"
#import "StoryViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface LevelViewController () {
    NSMutableArray *_buttons; // buttons for different levels
    
    int _numLevels;           // total levels the game has
    int _possibleLevels;
    
    int rows;
    int cols;
    
    AVAudioPlayer *_audioPlayerLevelPressed;
    AVAudioPlayer *_audioPlayerMenuPressed;
    AVAudioPlayer *_audioPlayerNo;
    
    int selectedLevel;        // current selected level
    BOOL test;                // if test is on, all levels are unlocked
    
    NSDictionary* levelMenuText;
}

@end

@implementation LevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BGplain.png"]]];
    
    _numLevels = 28;
    _possibleLevels = 28;

    rows = 7;
    cols = 4;
    test = NO;        // turn on test for debugging
    
    if ([self.locks count] == 0)
        [self setUpLocks];
    
    [self setUpDictionary];
    [self setUpSounds];
    [self setUpButtons];
    
    // Do any additional setup after loading the view.
}

- (void) setUpDictionary {
    NSString *plistPath;
    switch (self.mainLanguage) {
        case ENGLISH:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"LevelMenuText" ofType:@"plist"];
            break;
            
        case SPANISH:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"LevelMenuTextSpanish" ofType:@"plist"];
            break;
            
        case CHINESE:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"LevelMenuTextChinese" ofType:@"plist"];
            break;
            
        default:
            break;
    }
    
    levelMenuText = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}


- (void)setUpSounds
{
    NSString *levelPath  = [[NSBundle mainBundle] pathForResource:@"mouse-doubleclick-02" ofType:@"wav"];
    NSURL *levelPathURL = [NSURL fileURLWithPath : levelPath];
    _audioPlayerLevelPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:levelPathURL error:nil];
    
    NSString *menuPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *menuPathURL = [NSURL fileURLWithPath : menuPath];
    _audioPlayerMenuPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:menuPathURL error:nil];
    
    NSString *noPath  = [[NSBundle mainBundle] pathForResource:@"beep-rejected" ofType:@"aif"];
    NSURL *noPathURL = [NSURL fileURLWithPath : noPath];
    _audioPlayerNo = [[AVAudioPlayer alloc] initWithContentsOfURL:noPathURL error:nil];
}

- (void)setUpButtons
{
    // level buttons set up
    _buttons = [[NSMutableArray alloc] init];
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat buttonWidth = frameWidth / 10;
    CGFloat buttonHeight = buttonWidth;
    CGFloat buttonHeightSpace = (frameHeight - buttonHeight * rows) / (rows + 1);
    CGFloat buttonWidthSpace = (frameWidth -buttonWidth * cols) / (cols + 1);
    
    for (int k = 0; k < rows; ++k){
        
        CGFloat y = buttonHeightSpace * (k + 1) + buttonHeight* k + 25;
        
        for (int p = 0 ; p < cols; ++p)
        {
            CGFloat x = buttonWidthSpace * (p + 1) + buttonWidth * p;
            
            CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
            
            UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
            
            int i = k * cols + p;
            button.tag = i;
            
            NSString *titleStr;
            titleStr = [NSString stringWithFormat:@"%d", i];
            
            [button setTitle:titleStr forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            if ([self.locks[i] integerValue] == 0)
                [button setBackgroundImage:[UIImage imageNamed:@"bulbon"] forState:UIControlStateNormal];
            else if ([self.locks[i] integerValue] == 1)
                [button setBackgroundImage:[UIImage imageNamed:@"bulb"] forState:UIControlStateNormal];
            else
                [button setBackgroundImage:[UIImage imageNamed:@"bombLRTB"] forState:UIControlStateNormal];
            
            [self.view addSubview:button];
            [_buttons addObject:button];
            
            [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // back to main menu button set up
    CGFloat buttonSize = frameWidth /16;
    CGFloat x = (frameWidth - buttonSize) / 2;
    CGFloat y = 25;
    CGRect buttonFrame = CGRectMake(x, y, buttonSize, buttonSize);
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"backButtonOn.png"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(backToMain:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:menuButton];
    

}

/*
 * initialize an array to store the lock state for each levels
 * 0: unlocked
 * 1: locked
 * 2: unavailable
 */
- (void)setUpLocks
{
    NSAssert(_numLevels > 1, @"The number of levels is too small");
    
    self.locks = [[NSMutableArray alloc] init];
    
    // first two levels are always unlocked
    int unlockLevels = 2;
    
    for (int i = 0; i < unlockLevels; ++i)
        [self.locks addObject: [NSNumber numberWithInt:0]];
    
    for (int i = unlockLevels; i < _numLevels; ++i){
        if (test)
            [self.locks addObject:[NSNumber numberWithInt:0]];
        else
            [self.locks addObject:[NSNumber numberWithInt:1]];
    }
    
    for (int i = _numLevels; i < _possibleLevels; ++i){
        [self.locks addObject: [NSNumber numberWithInt:2]];
    }
}

/*
 * if a button is pressed, segue to menu viewcontroller
 */
- (void)backToMain:(id)sender
{
    [_audioPlayerMenuPressed prepareToPlay];
    [_audioPlayerMenuPressed play];
    
    // go back to menu viewcontroller
    [self performSegueWithIdentifier:@"backToMain" sender:self];
}

/*
 * if a level is selected, segue to game viewcontroller
 */
- (void)cellSelected:(id)sender
{
    UIButton *button = (UIButton*) sender;
    int buttonTag = (int) button.tag;
    
    if (self.locks[buttonTag] == [NSNumber numberWithInt:1])
    {
        [_audioPlayerNo prepareToPlay];
        [_audioPlayerNo play];
        
        [self displayLockedMessage];
    } else if (self.locks[buttonTag] == [NSNumber numberWithInt:2]){
        [_audioPlayerNo prepareToPlay];
        [_audioPlayerNo play];
        
        [self displayUnavailableMessage];
    } else {
        [_audioPlayerLevelPressed prepareToPlay];
        [_audioPlayerLevelPressed play];
        
        selectedLevel = buttonTag;
        if ([StoryViewController needToDisplayStoryAtLevel:selectedLevel andState:self.currentState]) {
            [self performSegueWithIdentifier:@"Instructions" sender:self];
        } else {
            [self performSegueWithIdentifier:@"presentGame" sender:self];
        }
    }
}

/*
 *  Display message when user selects a locked level
 */
- (void)displayLockedMessage{
    
    NSString *title = [levelMenuText objectForKey:@"lockTitle"];
    NSString *message = [levelMenuText objectForKey:@"lockMessage"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

/*
 *  Display message when user selects an unavailable level
 */
- (void)displayUnavailableMessage{
    
    NSString *title = [levelMenuText objectForKey:@"unavailableTitle"];
    NSString *message = [levelMenuText objectForKey:@"unavailableMessage"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}

/*
 *  Pass data to main viewcontroller or game viewcontroller
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"backToMain"]) {
        MenuViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks        = self.locks;

    }
    
    if ([segue.identifier isEqualToString:@"presentGame"]) {
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.locks = self.locks;
        destViewController.totalLevel = _numLevels;
        destViewController.gameLevel = selectedLevel;
        destViewController.currentState = self.currentState;
    }
    
    if ([segue.identifier isEqualToString:@"Instructions"]) {
        StoryViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
        destViewController.totalLevel = _numLevels;
        destViewController.gameLevel = selectedLevel;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
