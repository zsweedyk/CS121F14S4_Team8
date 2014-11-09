//
//  GameViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

// Please add your comments on anything that you think can be improved

#import "GameViewController.h"
#import "LevelViewController.h"
#import "GameModel.h"
#import "Grid.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface GameViewController () <GridDelegate>
{
    int _level;     // current level
    int _numLevels; // total level
    int _language;  // language choice

    GameModel* _model;
    Grid* _grid;
    UIButton* _backToLevel;
    UIButton* _test;

    int _numRows;
    int _numCols;
    
    // message title variables
    NSString* _titleWin;
    NSString* _next;
    NSString* _all;
    NSString* _okay;
    NSString* _titleLose;
    NSString* _restart;
    
    // sound effect variables
    AVAudioPlayer* _audioPlayerWin;
    AVAudioPlayer* _audioPlayerNo;
}

@end

@implementation GameViewController

- (id) initWithLevel: (int) startLevel AndTotalLevels: (int) totalLevels AndLanguage: (int) language{
    _level = startLevel;
    _numLevels = totalLevels;
    _language = language;
    [self viewDidLoad];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // sound set up
    NSString *winPath  = [[NSBundle mainBundle] pathForResource:@"slide-magic" ofType:@"aif"];
    NSURL *winPathURL = [NSURL fileURLWithPath : winPath];
    _audioPlayerWin = [[AVAudioPlayer alloc] initWithContentsOfURL:winPathURL error:nil];
    
    NSString *noPath  = [[NSBundle mainBundle] pathForResource:@"beep-rejected" ofType:@"aif"];
    NSURL *noPathURL = [NSURL fileURLWithPath : noPath];
    _audioPlayerNo = [[AVAudioPlayer alloc] initWithContentsOfURL:noPathURL error:nil];
    
    // initialize model
    _model = [[GameModel alloc] initWithTotalLevels:_numLevels];

    // with the generated grid we know the number of rows and cols so we can set the variables
    _numRows = [_model getNumRows];
    _numCols = [_model getNumCols];
    
    // generate a grid
    [_model generateGrid:_level];

    [self initializeGrid];
    
    [self setUpDisplay];
    
    // set up back to level button
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat buttonWidth = frameWidth / 2;
    CGFloat buttonHeight = buttonWidth / 6;
    
    CGFloat x = (frameWidth - buttonWidth) / 2;
    CGFloat y = buttonHeight / 2;
    CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
    
    _backToLevel = [[UIButton alloc] initWithFrame:buttonFrame];
    [_backToLevel setBackgroundColor:[UIColor clearColor]];
    [_backToLevel setTitle:@"Back to level menu" forState:UIControlStateNormal];
    UIColor* tintColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    [_backToLevel setTitleColor:tintColor forState:UIControlStateNormal];

    [self.view addSubview:_backToLevel];

//    _test = [[UIButton alloc] initWithFrame:buttonFrame];
//    [_test setBackgroundColor:[UIColor clearColor]];
//    [_test setTitle:@"Test" forState:UIControlStateNormal];
//    UIColor* tintColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
//    [_test setTitleColor:tintColor forState:UIControlStateNormal];
//    [self.view addSubview:_test];
//    [_test addTarget:self action:@selector(backToLevel:) forControlEvents:UIControlEventTouchUpInside];
    
    [_backToLevel addTarget:self action:@selector(backToLevel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLanguage];
}

- (void) initializeGrid
{
    CGRect frame = self.view.frame;

    float framePortion = 0.8;
    CGFloat xGrid    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    CGFloat yGrid    = CGRectGetHeight(frame) * (1 - framePortion) / 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(xGrid, yGrid, size, size);

    // initialize the grid
    _grid = [[Grid alloc] initWithFrame:gridFrame andNumRows:_numRows andCols:_numCols];
    _grid.delegate = self;

    [self.view addSubview:_grid];
}

- (void) setLanguage
{
    switch (_language) {
        case 0:
            [_backToLevel setTitle:@"Back to Menu" forState:UIControlStateNormal];
            _titleWin = @"You win";
            _next = @"Current level is unlocked. Let's try next level!";
            _all = @"All levels are unlocked. Congratulation!";
            _okay = @"OK";
            _titleLose = @"You lose";
            _restart = @"The circuit is shorted. Let's give it another try!";
            break;
        case 1:
            [_backToLevel setTitle:@"Volver al menú" forState:UIControlStateNormal];
            _titleWin = @"You win (spanish)";
            _next = @"Current level is unlocked. Let's try next level! (spanish)";
            _all = @"All levels are unlocked. Congratulation! (spanish)";
            _okay = @"OK";
            _titleLose = @"You lose (spanish)";
            _restart = @"The circuit is shorted. Let's give it another try! (spanish)";
            break;
        case 2:
            [_backToLevel setTitle:@"回到主菜单" forState:UIControlStateNormal];
            _titleWin = @"成功过关！";
            _next = @"下关已解锁！";
            _all = @"所有关卡已解锁！";
            _okay = @"进入下一关";
            _titleLose = @"你没有过关";
            _restart = @"再试一次吧！";
            break;
        default:
            break;
    }
}

- (void)backToLevel:(id)sender
{
    // go back to levelviewcontroller
    [self.navigationController popViewControllerAnimated:YES];
    //[self newLevel];
}

- (void) newLevel{
    ++_level;
    [_model generateGrid:_level];

    [self setUpDisplay];
}

- (void) setUpDisplay{
    // reset all grids
    [_grid setUpGrid];
    
    // read values from gameModel and set them to grid
    for (int row = 0; row < _numRows; ++row){
        for (int col = 0; col < _numCols; ++col){
            NSString* componentType = [_model getTypeAtRow:row andCol:col];
            [_grid setValueAtRow:row col:col to:componentType];
        }
    }
    
}

- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation
{
    int rowSelected = [position[0] intValue];
    int colSelected = [position[1] intValue];
    [_model switchSelectedAtRow:rowSelected andCol:colSelected withOrientation:newOrientation];
}

// if the battery is on, check the circuit connection
-(void) powerOn{
    bool shorted = [_model shorted];
    bool connected = [_model connected];
    NSArray* connectedBulbs = [_model bulbIndices]; // the array stores the indices of all connected bulbs
    [_grid bulbConnectedWithIndices:connectedBulbs]; // light up bulbs that are connected
    
    // if the circuit is shorted, explode the battery, and display lose message
    // the message will ask the user to restart the game
    if (shorted) {
        [_grid shorted];
        
        if (_language == 2) {
            _okay = @"好";
        }
        
        UIAlertView *loseView = [[UIAlertView alloc] initWithTitle:_titleLose
                                                          message:_restart
                                                         delegate:self
                                                cancelButtonTitle:_okay otherButtonTitles:nil];
        loseView.tag = 0; // To determine the alert view is a losing view
        
        [loseView show];
    }
    // light up the connected bulbs
    // if all bulbs are connected, display win message,
    // and the message will ask the user to go to next level
    // if current level is the last level, nothing will happen
    else if (connected){
        [_audioPlayerWin prepareToPlay];
        [_audioPlayerWin play];
        
        NSString *message;
        if (_level < _numLevels ) {
            message = _next;
        } else {
            message = _all;
            if (_language == 2) {
                _okay = @"退出游戏";
            }
        }

        UIAlertView *winView = [[UIAlertView alloc] initWithTitle:_titleWin
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:_okay otherButtonTitles:nil];
        winView.tag = 1; // To determine the alert view is a win view
        
        [winView show];
    }
    // if neither shorted or connected, do nothing but play sound that indicates a bad move
    else {
        [_audioPlayerNo prepareToPlay];
        [_audioPlayerNo play];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // if the circuit is shorted, restart the current level
    // if the circuit is not shorted and connected, go to the next level
    if (alertView.tag == 0){
        _level--;
        [self newLevel];
    }
    else if (_level < _numLevels - 1)
        [self newLevel];
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

