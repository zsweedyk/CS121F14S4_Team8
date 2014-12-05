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
    NSMutableArray* _buttons; // buttons for different levels
    
    int _numLevels;           // total levels the game has
    int _possibleLevels;
    
    AVAudioPlayer* _audioPlayerLevelPressed;
    AVAudioPlayer* _audioPlayerMenuPressed;
    AVAudioPlayer* _audioPlayerNo;
    
    int selectedLevel;        // current selected level
    BOOL test;                // if test is on, all levels are unlocked
}

@end

@implementation LevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _numLevels = 10;
    _possibleLevels = 20;
    test = YES;        // turn on test for debugging
    
    if ([self.locks count] == 0)
        [self setUpLocks];
    
    [self setUpSounds];
    [self setUpButtons];
    
    // Do any additional setup after loading the view.
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
    // set up tint color
    UIColor* tintColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    
    // level buttons set up
    _buttons = [[NSMutableArray alloc] init];
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat buttonWidth = frameWidth / 10;
    CGFloat buttonHeight = buttonWidth;
    CGFloat buttonHeightSpace = (frameHeight - buttonHeight * 5) / 6;
    CGFloat buttonWidthSpace = (frameWidth -buttonWidth * 4) / 5;
    
    for (int k = 0; k < 5; k++){
        
        CGFloat y = buttonHeightSpace * (k + 1) + buttonHeight* k;
        
        for (int p = 0 ; p < 4; p++)
        {
            CGFloat x = buttonWidthSpace * (p + 1) + buttonWidth * p;
            
            CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
            
            UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
            
            int i = k * 4 + p;
            button.tag = i;
            
            NSString* titleStr;
            if (self.mainLanguage == 2)
                titleStr = [NSString stringWithFormat:@"%d", i];
            else if (self.mainLanguage == 1)
                titleStr = [NSString stringWithFormat:@"%d", i];
            else
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
    buttonWidth = frameWidth / 2;
    buttonHeight = buttonWidth / 6;

    CGFloat xMain = (frameWidth - buttonWidth) / 2;
    CGFloat yMain = buttonHeight / 2;
    
    CGRect menuButtonFrame = CGRectMake(xMain, yMain, buttonWidth, buttonHeight);
    
    UIButton* menuButton = [[UIButton alloc] initWithFrame:menuButtonFrame];
    
    [menuButton setBackgroundColor:[UIColor clearColor]];
    
    NSString* backtoMenu;
    if (self.mainLanguage == CHINESE)
        backtoMenu = @"回到主菜单";
    else if (self.mainLanguage == SPANISH)
        backtoMenu = @"Volver al menú principal";
    else
        backtoMenu = @"Back to main menu";
    
    [menuButton setTitle:backtoMenu forState:UIControlStateNormal];
    [menuButton setTitleColor:tintColor forState:UIControlStateNormal];
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
    
    for (int i = 0; i < unlockLevels; i++)
        [self.locks addObject: [NSNumber numberWithInt:0]];
    
    for (int i = unlockLevels; i < _numLevels; i++){
        if (test)
            [self.locks addObject:[NSNumber numberWithInt:0]];
        else
            [self.locks addObject:[NSNumber numberWithInt:1]];
    }
    
    for (int i = _numLevels; i < _possibleLevels; i++){
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
    UIButton* button = (UIButton*) sender;
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
    NSString *title;
    NSString *message;
    
    // change the language of help message based on language choice
    switch (self.mainLanguage) {
        case ENGLISH:
            title = @"Current level is locked";
            message = @"Please unlock all previous levels to play current level.";
            break;
        case SPANISH:
            title = @"Nivel actual está bloqueado";
            message = @"Para jugar a este nivel, desbloquear todos los niveles anteriores";
            break;
        case CHINESE:
            title = @"当前关卡未解锁";
            message = @"只有解锁之前的所有关卡才可以开始这关";
            break;
        default:
            break;
    }
    
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
    NSString *title;
    NSString *message;
    
    // change the language of help message based on language choice
    switch (self.mainLanguage) {
        case ENGLISH:
            title = @"Current level is unavailbe";
            message = @"Please play available levels for now.";
            break;
        case SPANISH:
            title = @"Nivel actual está bloqueado";
            message = @"Para jugar a este nivel, desbloquear todos los niveles anteriores";
            break;
        case CHINESE:
            title = @"当前关卡正在开发";
            message = @"先试试别的关卡吧！";
            break;
        default:
            break;
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
