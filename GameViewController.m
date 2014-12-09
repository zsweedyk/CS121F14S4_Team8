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
#import "StoryViewController.h"
#import "GameModel.h"
#import "Grid.h"
#import "ExplosionScene.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface GameViewController () <GridDelegate>
{
    // general variables
    GameModel* _model;
    Grid* grid;
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

const int POSITION_DECODER = 100;

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BGgame.png"]]];
    
    // initialize model
    _model = [[GameModel alloc] initWithTotalLevels:(int)self.totalLevel];

    // with the generated grid we know the number of rows and cols so we can set the variables
    _numRows = [_model rows];
    _numCols = [_model cols];
    
    // generate a grid
    [_model generateGrid:(int)self.gameLevel];

    [self setUpSound];
    [self initializeGrid];
    [self setUpDisplayWithPower:NO];
    [self setUpBackButton];
    [self setLanguage];
}

#pragma mark - Private Methods

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

    framePortion = 0.9;
    xGrid    = CGRectGetWidth(frame) * (1 - framePortion) / 2;
    yGrid    = CGRectGetHeight(frame) * (1 - framePortion) * 2;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * framePortion;
    CGRect gridFrame = CGRectMake(xGrid, yGrid, size, size);

    // initialize the grid
    grid = [[Grid alloc] initWithFrame:gridFrame andNumRows:_numRows andCols:_numCols];
    grid.delegate = self;

    [self.view addSubview:grid];
}

/*
 * change display language for alertviews
 */
- (void) setLanguage
{
    switch (self.mainLanguage) {
        case ENGLISH:
            [_backToLevel setTitle:@"Back to Menu" forState:UIControlStateNormal];
            _titleWin = @"You win";
            _next = @"Current level is unlocked. Let's try next level!";
            _all = @"All levels are unlocked. Congratulation!";
            _okay = @"OK";
            _titleLose = @"You lose";
            _restart = @"The circuit is shorted. Let's give it another try!";
            _restartBomb = @"The bomb is activated. Let's give it another try!";
            break;
        case SPANISH:
            [_backToLevel setTitle:@"Volver al menú" forState:UIControlStateNormal];
            _titleWin = @"Ganaste!";
            _next = @"El proximo Nivel está desbloqueado. Vamos a intentar siguiente nivel!";
            _all = @"Todos los niveles están desbloqueados. ¡Enhorabuena!";
            _okay = @"OK";
            _titleLose = @"Pierdes";
            _restart = @"El circuito está en cortocircuito. Vamos a intentar otra vez!";
            _restartBomb = @"The circuit is shorted. Let's give it another try! (spanish)";
            break;
        case CHINESE:
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
    NSAssert(self.gameLevel < self.totalLevel, @"Level out of bound");

    ++self.gameLevel;
    [_model generateGrid:(int)self.gameLevel];

    // reset all game parameters
    masterPowerOn = NO;
    
    [self setUpDisplayWithPower:NO];
}

/*
 * set up display on the grid
 */
- (void) setUpDisplayWithPower:(BOOL)power{
    // reset all grids
    [grid clearGrid];
    [grid setUpGrid];
    
    // read values from gameModel and set them to grid
    for (int row = 0; row < _numRows; ++row){
        for (int col = 0; col < _numCols; ++col){
            [self updateDisplayAtRow:row AndCol:col WithPower:power];
        }
    }
}

- (void) componentSelectedAtPosition:(NSNumber*)position WithConnections:(NSString*)newConnection {

    int rowSelected = [position intValue] / POSITION_DECODER;
    int colSelected = [position intValue] % POSITION_DECODER;
    
    [_model componentSelectedAtRow:rowSelected andCol:colSelected WithConnections:newConnection];

    [self setUpDisplayWithPower:masterPowerOn];
    
    [self circuitOn];
}

- (void) componentAdjustedAtPosition:(NSNumber*)position WithConnections:(NSString*)newConnection {
    NSLog(@"Parameters in view controller. Position:%@, and connection:%@",position, newConnection);
    int row = [position intValue] / POSITION_DECODER;
    int col = [position intValue] % POSITION_DECODER;
    
    [_model componentSelectedAtRow:row andCol:col WithConnections:newConnection];
    
    NSArray* updatedComponents = [_model getLasers];
    NSLog(@"%lu Lasers that need to be updated:%@",(unsigned long)updatedComponents.count , updatedComponents);
    [self updateDisplayFor:updatedComponents];
    [self circuitOn];
}

- (void) updateDisplayFor:(NSArray*)components {
    for (NSNumber *component in components) {
        int row = [component intValue] / POSITION_DECODER;
        int col = [component intValue] % POSITION_DECODER;
        
        [self updateDisplayAtRow:row AndCol:col WithPower:YES];
    }
}

- (void) updateDisplayAtRow:(int)row AndCol:(int)col WithPower:(BOOL)power {

    enum COMPONENTS componentType = [_model getTypeAtRow:row andCol:col];
    enum DIRECTION direction = [_model getDirectionAtRow:row andCol:col];
    NSString *connections = [_model getConnectionAtRow:row andCol:col];
    BOOL state = [_model getStateAtRow:row andCol:col];
    
    if (componentType != LASER || power) {
        [grid setValueAtRow:row Col:col To:componentType WithDirection:direction AndConnections:connections];
    }
    
    if (power && state) {
        [grid turnOnAtRow:row AndCol:col];
    }
}

///*
// * If the battery was turned on, power on and update
// */
//-(void) powerOn
//{
//    [_model powerOn];
//    [self updateGrid];
//}

///*
// * If the battery was turned off, reset components
// */
//- (void) powerOff
//{
//    [_model powerOff];
//    [_grid resetLasers];
//    [_grid componentsTurnedOff];
//}

/*
 * Switch the power on choice
 */
-(void) masterPowerSelected
{
    masterPowerOn = !masterPowerOn;
    
    [self setUpDisplayWithPower:masterPowerOn];
    
    [_model updateGameStatus];
    
    [self circuitOn];
}

- (void) circuitOn {
    if (masterPowerOn) {
        if ([_model shorted]) {
            [_audioPlayerExplosion prepareToPlay];
            [_audioPlayerExplosion play];
            [self setUpExplosionScene];
            [self explodeBattery];
            [self displayMessageFor:@"Lose"];
            
        } else if ([_model exploded]) {
            [_audioPlayerExplosion prepareToPlay];
            [_audioPlayerExplosion play];
            [self setUpExplosionScene];
            [self explodeBombs:[_model getConnectedBombs]];
            [self displayMessageFor:@"Bombs"];
            
        } else if ([_model complete]) {
            [_audioPlayerWin prepareToPlay];
            [_audioPlayerWin play];
            [self displayMessageFor:@"Win"];
        }
    }
}

//
//- (void) updateGrid
//{
//    NSArray* lasers = [_model getLasers];
//    NSArray* emitters = [_model getConnectedEmitters];
//    NSArray* deflectors = [_model getConnectedDeflectors];
//    NSArray* receivers = [_model getConnectedReceivers];
//    NSArray* bulbs = [_model getConnectedBulbs];
//    NSArray* bombs = [_model getConnectedBombs];
//    
//    [_grid resetLasers];
//    [self updateComponents:lasers];
//    [self updateStates:emitters];
//    [self updateStates:deflectors];
//    [self updateStates:receivers];
//    [self updateStates:bulbs];
//    
//    BOOL shorted = [_model isShorted];
//    BOOL connected = [_model isConnected];
//    BOOL bombConnected = [_model isBombConnected];
//    
//    // first check bomb connection, then short circuit, and finally connected circuit
//    if (bombConnected) {
//        // if the bomb is connected, explode that bomb, and display lose message
//        // the message will ask the user to restart the game
//        [_audioPlayerExplosion prepareToPlay];
//        [_audioPlayerExplosion play];
//        
//        [self setUpExplosionScene];
//        [self explodeBombs:bombs];
//        
//        [self displayMessageFor:@"Bomb"];
//        
//    } else if (shorted) {
//        // if the circuit is shorted, explode the battery, and display lose message
//        // the message will ask the user to restart the game
//        [_audioPlayerExplosion prepareToPlay];
//        [_audioPlayerExplosion play];
//        
//        [self setUpExplosionScene];
//        [self explodeBattery];
//        
//        [_grid shorted];
//        
//        [self displayMessageFor:@"Lose"];
//        
//    } else if (connected){
//        // if the circuit is connected, display win message
//        // the message will ask the user to go to the next level
//        [_audioPlayerWin prepareToPlay];
//        [_audioPlayerWin play];
//        
//        [self displayMessageFor:@"Win"];
//    } else {
//        // if neither shorted or connected, do nothing but play sound that indicates a bad move
//        [_audioPlayerNo prepareToPlay];
//        [_audioPlayerNo play];
//    }
//}

/*
 * Display alert view
 */
- (void) displayMessageFor:(NSString*)win
{
    NSString* title;
    NSString* message;
    if ([win isEqual:@"Win"]) {
        title = _titleWin;
        
        if (self.gameLevel < self.totalLevel) {
            message = _next;
        } else {
            message = _all;
            if (self.mainLanguage == 2) {
                _okay = @"退出游戏";
            }
        }
    } else if ([win isEqual:@"Lose"]){
        title = _titleLose;
        message = _restart;
        if (self.mainLanguage == 2) {
            _okay = @"好";
        }
    } else {
        title = _titleLose;
        message = _restartBomb;
        if (self.mainLanguage == 2) {
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

///*
// * change component type on grid
// */
//- (void) updateComponents:(NSArray*)components
//{
//    NSArray* rows = components[0];
//    NSArray* cols = components[1];
//    
//    for (int i = 0; i < rows.count; ++i) {
//        NSString* compName = [_model getTypeAtRow:[rows[i] intValue] andCol:[cols[i] intValue]];
//        [_grid setValueAtRow:[rows[i] intValue] col:[cols[i] intValue] to:compName];
//    }
//}

///*
// * update a component state on grid if they have been pressed
// */
//- (void) updateStates:(NSArray*)components
//{
//    if (components.count > 0) {
//        NSArray* rows = components[0];
//        NSArray* cols = components[1];
//        NSArray* states = components[2];
//        
//        for (int i = 0; i < rows.count; ++i) {
//            [_grid setStateAtRow:[rows[i] intValue] AndCol:[cols[i] intValue] to:[states[i] boolValue]];
//        }
//    }
//}

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
    int xPos = [grid getBatteryX] + xGrid;
    int yPos = [grid getBatteryY] + yGrid;
    NSLog(@"Battery Explosion At x:%d and y:%d", xPos, yPos);
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
    
    for (int i = 0; i < bombs.count; ++i) {
        int row = [bombs[i] intValue] / POSITION_DECODER;
        int col = [bombs[i] intValue] % POSITION_DECODER;
        
        int xPos = [grid getBombXAtRow:row AndCol:col] + xGrid;
        int yPos = [grid getBombYAtRow:row AndCol:col] + yGrid;
        
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
        --self.gameLevel;
        [self newLevel];
    }
    else if (self.gameLevel < self.totalLevel - 1)
    {
        if ([StoryViewController needToDisplayStoryAtLevel:(int)self.gameLevel+1 andState:self.currentState]) {
            ++self.gameLevel;
            [self performSegueWithIdentifier:@"GameToStory" sender:self];
        } else {
            [self newLevel];
            self.locks[self.gameLevel] = [NSNumber numberWithInt:0];
        }
    }
}

#pragma mark - Navigation

/*
 * pass data to level viewcontroller
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backToLevel"]) {
        LevelViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.locks = self.locks;
        destViewController.currentState = self.currentState;
    }
    
    if ([segue.identifier isEqualToString:@"GameToStory"]) {
        StoryViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
        destViewController.gameLevel = self.gameLevel;
        destViewController.totalLevel = self.totalLevel;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

