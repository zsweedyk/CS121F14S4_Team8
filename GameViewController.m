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
#import "ExplosionScene.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface GameViewController () <GridDelegate>
{
    // general variables
    GameModel* _model;
    Grid* _grid;
    int _numRows;
    int _numCols;
    UIButton* _backToLevel;
    UIButton* _test;
    
    // message title variables
    NSString* _titleWin;
    NSString* _next;
    NSString* _all;
    NSString* _okay;
    NSString* _titleLose;
    NSString* _restartBomb;
    NSString* _restart;
    
    // sound effect variables
    AVAudioPlayer* _audioPlayerWin;
    AVAudioPlayer* _audioPlayerNo;
    AVAudioPlayer* _audioPlayerExplosion;
    AVAudioPlayer* _audioPlayerLevelPressed;
    
    // position variables
    float framePortion;
    CGFloat xGrid;
    CGFloat yGrid;
    
    // explosion effect variables
    SKView* _background;
    ExplosionScene* _explosion;
    
    // other variables
    BOOL masterPowerOn;
}

@end

@implementation GameViewController

@synthesize gameLanguage;
@synthesize gameLevel;
@synthesize totalLevel;
@synthesize locks;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // initialize model
    _model = [[GameModel alloc] initWithTotalLevels:(int)totalLevel];

    // with the generated grid we know the number of rows and cols so we can set the variables
    _numRows = [_model getNumRows];
    _numCols = [_model getNumCols];
    
    // generate a grid
    [_model generateGrid:(int)gameLevel];

    [self setUpSound];
    [self initializeGrid];
    [self setUpDisplay];
    [self setUpBackButton];
    [self setLanguage];
}

- (void) setUpBackButton
{
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
    
    [_backToLevel addTarget:self action:@selector(backToLevel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setUpSound
{
    NSString *winPath  = [[NSBundle mainBundle] pathForResource:@"slide-magic" ofType:@"aif"];
    NSURL *winPathURL = [NSURL fileURLWithPath : winPath];
    _audioPlayerWin = [[AVAudioPlayer alloc] initWithContentsOfURL:winPathURL error:nil];
    
    NSString *noPath  = [[NSBundle mainBundle] pathForResource:@"beep-rejected" ofType:@"aif"];
    NSURL *noPathURL = [NSURL fileURLWithPath : noPath];
    _audioPlayerNo = [[AVAudioPlayer alloc] initWithContentsOfURL:noPathURL error:nil];
    
    NSString *explosionPath  = [[NSBundle mainBundle] pathForResource:@"bomb-02" ofType:@"wav"];
    NSURL *explosionPathURL = [NSURL fileURLWithPath : explosionPath];
    _audioPlayerExplosion = [[AVAudioPlayer alloc] initWithContentsOfURL:explosionPathURL error:nil];
    
    NSString *levelPath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *levelPathURL = [NSURL fileURLWithPath : levelPath];
    _audioPlayerLevelPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:levelPathURL error:nil];
}

- (void) initializeGrid
{
    // reset master power off
    masterPowerOn = NO;
    
    CGRect frame = self.view.frame;

    framePortion = 0.8;
    xGrid    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    yGrid    = CGRectGetHeight(frame) * (1 - framePortion) / 1;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(xGrid, yGrid, size, size);

    // initialize the grid
    _grid = [[Grid alloc] initWithFrame:gridFrame andNumRows:_numRows andCols:_numCols];
    _grid.delegate = self;

    [self.view addSubview:_grid];
}

/*
 * change display language for alertviews
 */
- (void) setLanguage
{
    switch (gameLanguage) {
        case 0:
            [_backToLevel setTitle:@"Back to Menu" forState:UIControlStateNormal];
            _titleWin = @"You win";
            _next = @"Current level is unlocked. Let's try next level!";
            _all = @"All levels are unlocked. Congratulation!";
            _okay = @"OK";
            _titleLose = @"You lose";
            _restart = @"The circuit is shorted. Let's give it another try!";
            _restartBomb = @"The bomb is activated. Let's give it another try!";
            break;
        case 1:
            [_backToLevel setTitle:@"Volver al menú" forState:UIControlStateNormal];
            _titleWin = @"Ganas!";
            _next = @"Nivel actual está desbloqueado. Vamos a intentar siguiente nivel!";
            _all = @"Todos los niveles están desbloqueados. ¡Enhorabuena!";
            _okay = @"OK";
            _titleLose = @"Pierdes";
            _restart = @"El circuito está en cortocircuito. Vamos a intentar otra vez!";
            _restartBomb = @"The circuit is shorted. Let's give it another try! (spanish)";
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

/*
 * segue back to level viewcontroller
 */
- (void)backToLevel:(id)sender
{
    [_audioPlayerLevelPressed prepareToPlay];
    [_audioPlayerLevelPressed play];
    
    // go back to levelviewcontroller
    [self performSegueWithIdentifier:@"backToLevel" sender:self];
}

/*
 * move to the next level
 */
- (void) newLevel{
    NSAssert(gameLevel < totalLevel, @"Level out of bound");

    ++gameLevel;
    [_model generateGrid:(int)gameLevel];

    // reset master power off
    masterPowerOn = NO;
    
    [self setUpDisplay];
}

/*
 * set up display on the grid
 */
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

- (void) componentSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)newOrientation
{
    int rowSelected = [position[0] intValue];
    int colSelected = [position[1] intValue];
    
    masterPowerOn = NO;
    [self powerOff];

    [_model componentSelectedAtRow:rowSelected andCol:colSelected withOrientation:newOrientation];
}

/*
 * If the battery was turned on, power on and update
 */
-(void) powerOn
{
    [_model powerOn];
    [self updateGrid];
}

/*
 * If the battery was turned off, reset components
 */
- (void) powerOff
{
    [_model powerOff];
    [_grid batteryTurnedOff];
    [_grid bulbTurnedOff];
    [_grid resetLasers];
}

/*
 * Switch the power on choice
 */
-(void) masterPowerSelected
{
    masterPowerOn = !masterPowerOn;
    
    if (masterPowerOn) {
        [self powerOn];
    } else {
        [self powerOff];
    }
}

- (void) updateGrid
{
    NSArray* lasers = [_model getLasers];
    NSArray* emitters = [_model getConnectedEmitters];
    NSArray* deflectors = [_model getConnectedDeflectors];
    NSArray* receivers = [_model getConnectedReceivers];
    NSArray* bulbs = [_model getConnectedBulbs];
    NSArray* bombs = [_model getConnectedBombs];
    
    [_grid resetLasers];
    [self updateComponents:lasers];
    [self updateStates:emitters];
    [self updateStates:deflectors];
    [self updateStates:receivers];
    [self updateStates:bulbs];
    
    BOOL shorted = [_model isShorted];
    BOOL connected = [_model isConnected];
    BOOL bombConnected = [_model isBombConnected];
    
    // first check bomb connection, then short circuit, and finally connected circuit
    if (bombConnected) {
        // if the bomb is connected, explode that bomb, and display lose message
        // the message will ask the user to restart the game
        [_audioPlayerExplosion prepareToPlay];
        [_audioPlayerExplosion play];
        
        [self setUpExplosionScene];
        [self explodeBombs:bombs];
        
        [self displayMessageFor:@"Bomb"];
        
    } else if (shorted) {
        // if the circuit is shorted, explode the battery, and display lose message
        // the message will ask the user to restart the game
        [_audioPlayerExplosion prepareToPlay];
        [_audioPlayerExplosion play];
        
        [self setUpExplosionScene];
        [self explodeBattery];
        
        [_grid shorted];
        
        [self displayMessageFor:@"Lose"];
        
    } else if (connected){
        // if the circuit is connected, display win message
        // the message will ask the user to go to the next level
        [_audioPlayerWin prepareToPlay];
        [_audioPlayerWin play];
        
        [self displayMessageFor:@"Win"];
    } else {
        // if neither shorted or connected, do nothing but play sound that indicates a bad move
        [_audioPlayerNo prepareToPlay];
        [_audioPlayerNo play];
    }
}

/*
 * Display alert view
 */
- (void) displayMessageFor:(NSString*)win
{
    NSString* title;
    NSString* message;
    if ([win isEqual:@"Win"]) {
        title = _titleWin;
        
        if (gameLevel < totalLevel) {
            message = _next;
        } else {
            message = _all;
            if (gameLanguage == 2) {
                _okay = @"退出游戏";
            }
        }
    } else if ([win isEqual:@"Lose"]){
        title = _titleLose;
        message = _restart;
        if (gameLanguage == 2) {
            _okay = @"好";
        }
    } else {
        title = _titleLose;
        message = _restartBomb;
        if (gameLanguage == 2) {
            _okay = @"好";
        }
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:_okay otherButtonTitles:nil, nil];
    
    if ([win isEqual:@"Win"]) {
        alert.tag = 1;
    } else {
        alert.tag = 0;
    }
    
    [alert show];
    
}

/*
 * change component type on grid
 */
- (void) updateComponents:(NSArray*)components
{
    NSArray* rows = components[0];
    NSArray* cols = components[1];
    
    for (int i = 0; i < rows.count; ++i) {
        NSString* compName = [_model getTypeAtRow:[rows[i] intValue] andCol:[cols[i] intValue]];
        [_grid setValueAtRow:[rows[i] intValue] col:[cols[i] intValue] to:compName];
    }
}

/*
 * update a component state on grid if they have been pressed
 */
- (void) updateStates:(NSArray*)components
{
    if (components.count > 0) {
        NSArray* rows = components[0];
        NSArray* cols = components[1];
        NSArray* states = components[2];
        
        for (int i = 0; i < rows.count; ++i) {
            [_grid setStateAtRow:[rows[i] intValue] AndCol:[cols[i] intValue] to:[states[i] boolValue]];
        }
    }
}

/*
 * prepare for explosion effect
 */
-(void) setUpExplosionScene
{
    // background set up
    _background = [[SKView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_background];
    [self.view sendSubviewToBack:_background]; // put background to the back of all views
    
    // set up explosion scene
    _explosion = [[ExplosionScene alloc] initWithSize:self.view.frame.size];
    _explosion.backgroundColor = [UIColor blackColor];
    [_background presentScene: _explosion];
}

/*
 * explode battery
 */
-(void) explodeBattery
{
    int xPos = [_grid getBatteryX] + xGrid;
    int yPos = [_grid getBatteryY] + yGrid;
    int frameY = self.view.frame.size.height;
    int xPoint = xPos + 50;
    int yPoint = frameY - yPos - 10;
    [_explosion createExplosionAtX:xPoint AndY:yPoint];
}

/*
 * explode connected bombs
 */
-(void) explodeBombs:(NSArray*)bombs
{
    int frameY = self.view.frame.size.height;
    
    NSArray* bombsRow = bombs[1];
    NSArray* bombsCol = bombs[0];
    
    for (int i = 0; i < bombsRow.count; ++i) {
        int xPos = [_grid getBombXAtRow:[bombsRow[i] intValue] AndCol:[bombsCol[i] intValue]] + xGrid;
        int yPos = [_grid getBombYAtRow:[bombsRow[i] intValue] AndCol:[bombsCol[i] intValue]] + yGrid;
        
        int xPoint = xPos + 25;
        int yPoint = frameY - yPos - 10;
        [_explosion createExplosionAtX:xPoint AndY:yPoint];
    }
}

/*
 * if the circuit is shorted or bombed, the user can restart the current level
 * if the circuit is well connected, the user can go to the next level
 */
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_background removeFromSuperview];
    
    // if the circuit is shorted, restart the current level
    // if the circuit is not shorted and connected, go to the next level
    if (alertView.tag == 0){
        gameLevel--;
        [self newLevel];
    }
    else if (gameLevel < totalLevel - 1)
    {
        [self newLevel];
        locks[gameLevel] = [NSNumber numberWithInt:0];
    }
}

/*
 * pass data to level viewcontroller
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backToLevel"]) {
        LevelViewController *destViewController = segue.destinationViewController;
        destViewController.levelLanguage = gameLanguage;
        destViewController.lock = locks;
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

