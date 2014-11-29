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
    [_backToLevel setTitle:NSLocalizedString(@"Back to Menu", nil) forState:UIControlStateNormal];
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
    
    NSString* selectedCompType = [_model getTypeAtRow:rowSelected andCol:colSelected];
    
    [_model componentSelectedAtRow:rowSelected andCol:colSelected withOrientation:newOrientation];
    
    if ([selectedCompType isEqual:@"switch"]) {
        masterPowerOn = NO;
        [self powerOff];
    } else if ([selectedCompType isEqual:@"deflector"]) {
        if (masterPowerOn) {
            [self powerOn];
        }
    }


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
    [_grid resetLasers];
    [_grid componentsTurnedOff];
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
        
        [self displayMessageForBomb];
        
    } else if (shorted) {
        // if the circuit is shorted, explode the battery, and display lose message
        // the message will ask the user to restart the game
        [_audioPlayerExplosion prepareToPlay];
        [_audioPlayerExplosion play];
        
        [self setUpExplosionScene];
        [self explodeBattery];
        
        [_grid shorted];
        
        [self displayMessageForShort];
        
    } else if (connected){
        // if the circuit is connected, display win message
        // the message will ask the user to go to the next level
        [_audioPlayerWin prepareToPlay];
        [_audioPlayerWin play];
        
        [self displayMessageForWin];
    } else {
        // if neither shorted or connected, do nothing but play sound that indicates a bad move
        [_audioPlayerNo prepareToPlay];
        [_audioPlayerNo play];
    }
}

/*
 * Display alert views
 */
- (void) displayMessageForWin
{
    NSString* message;
    if (gameLevel < totalLevel) {
        message = NSLocalizedString(@"Level Unlocked", nil);
    } else {
        message = NSLocalizedString(@"All Unlocked", nil);
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You Win", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    
    alert.tag = 1;
    [alert show];
}

- (void) displayMessageForShort
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You Lose", nil) message:NSLocalizedString(@"Circuit Shorted", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    
    alert.tag = 0;
    [alert show];
}

- (void) displayMessageForBomb
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You Lose", nil) message:NSLocalizedString(@"Bomb Activated", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    
    alert.tag = 0;
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

