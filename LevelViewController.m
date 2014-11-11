//
//  LevelViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

// Please add your comments on anything that you think can be improved

#import "LevelViewController.h"
#import "GameViewController.h"
#import "MenuViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface LevelViewController () {
    NSMutableArray* _buttons; // buttons for different levels
    
    int _language;
    int _numLevels; // total levels the game has
    int _currentLevel;
    
    AVAudioPlayer* _audioPlayerLevelPressed;
    AVAudioPlayer* _audioPlayerMenuPressed;
}

@end

@implementation LevelViewController

- (id) initWithLanguage: (int) language {
    _language = language;
    [self viewDidLoad];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _numLevels = 6;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // set up sounds
    NSString *levelPath  = [[NSBundle mainBundle] pathForResource:@"mouse-doubleclick-02" ofType:@"wav"];
    NSURL *levelPathURL = [NSURL fileURLWithPath : levelPath];
    _audioPlayerLevelPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:levelPathURL error:nil];
    
    NSString *menuPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *menuPathURL = [NSURL fileURLWithPath : menuPath];
    _audioPlayerMenuPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:menuPathURL error:nil];
    
    // set up tint color
    UIColor* tintColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    
    // level buttons set up
    _buttons = [[NSMutableArray alloc] init];
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat buttonWidth = frameWidth / 2;
    CGFloat buttonHeight = buttonWidth / 3;
    CGFloat buttonSpace = frameHeight / (_numLevels * 2);
    
    for (int i = 0; i < _numLevels; i++){
        CGFloat x = (frameWidth - buttonWidth) / 2;
        CGFloat y = 2 * buttonSpace + buttonSpace * i;
        CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
        
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        button.tag = i;
        
        [button setBackgroundColor:[UIColor clearColor]];
        
        NSString* titleStr;
        if (_language == 2)
            titleStr = [NSString stringWithFormat:@"关卡 %d", i];
        else if (_language == 1)
            titleStr = [NSString stringWithFormat:@"Level %d (spanish)", i];
        else
            titleStr = [NSString stringWithFormat:@"Level %d", i];
            
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        [_buttons addObject:button];
        
        [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // back to main menu button set up
    CGFloat xMain = (frameWidth - buttonWidth) / 2;
    CGFloat yMain = buttonHeight / 4;
    CGRect menuButtonFrame = CGRectMake(xMain, yMain, buttonWidth, buttonHeight);
    
    UIButton* menuButton = [[UIButton alloc] initWithFrame:menuButtonFrame];
    
    [menuButton setBackgroundColor:[UIColor clearColor]];
    
    NSString* backtoMenu;
    if (_language == 2)
        backtoMenu = @"回到主菜单";
    else if (_language == 1)
        backtoMenu = @"Back to main menu (spanish)";
    else
        backtoMenu = @"Back to main menu";
    
    [menuButton setTitle:backtoMenu forState:UIControlStateNormal];
    [menuButton setTitleColor:tintColor forState:UIControlStateNormal];
    
    [self.view addSubview:menuButton];
    
    [menuButton addTarget:self action:@selector(backToMain:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)backToMain:(id)sender
{
    [_audioPlayerMenuPressed prepareToPlay];
    [_audioPlayerMenuPressed play];
    
    // go back to root viewcontroller (menuviewcontroller)
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cellSelected:(id)sender
{
    [_audioPlayerLevelPressed prepareToPlay];
    [_audioPlayerLevelPressed play];
    
    UIButton* button = (UIButton*) sender;
    int buttonTag = (int) button.tag;
    
    GameViewController* gameVC = [[GameViewController alloc] initWithLevel:buttonTag AndTotalLevels:_numLevels AndLanguage:_language];
    
    // add gameviewcontroller to navigationviewcontroller stack
    [self.navigationController pushViewController:gameVC animated:YES];
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
