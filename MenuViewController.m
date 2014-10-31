//
//  MenuViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MenuViewController (){
    NSInteger language; // 0 english, 1 spanish, 2 chinese
    AVAudioPlayer* _audioPlayerLanguagePressed;
    AVAudioPlayer* _audioPlayerAboutPressed;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    language = 0;
    
    // sound set up
    NSString *languagePath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *languagePathURL = [NSURL fileURLWithPath : languagePath];
    _audioPlayerLanguagePressed = [[AVAudioPlayer alloc] initWithContentsOfURL:languagePathURL error:nil];
    
    NSString *aboutPath  = [[NSBundle mainBundle] pathForResource:@"beep-horn" ofType:@"aif"];
    NSURL *aboutPathURL = [NSURL fileURLWithPath : aboutPath];
    _audioPlayerAboutPressed = [[AVAudioPlayer alloc] initWithContentsOfURL:aboutPathURL error:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)indexChanged:(UISegmentedControl *)sender
{
    [_audioPlayerLanguagePressed prepareToPlay];
    [_audioPlayerLanguagePressed play];
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"english");
            language = 0;
            [self.level setTitle:@"Start new game" forState:UIControlStateNormal];
            [self.about setTitle:@"How to play" forState:UIControlStateNormal];
            break;
            
        case 1:
            NSLog(@"spanish");
            [self.level setTitle:@"Juego nuevo" forState:UIControlStateNormal];
            [self.about setTitle:@"Instrucción" forState:UIControlStateNormal];
            language = 1;
            break;
            
        case 2:
            NSLog(@"chinese");
            [self.level setTitle:@"开始新游戏" forState:UIControlStateNormal];
            [self.about setTitle:@"游戏指南" forState:UIControlStateNormal];
            language = 2;
            break;
            
        default:
            break;
    }
}

- (IBAction)displayHelpMessage:(UIButton*) sender{
    NSString *title;
    NSString *message;
    //[_audioPlayerAboutPressed prepareToPlay];
    //[_audioPlayerAboutPressed play];
    switch (language) {
        case 0:
            title = @"How to Play";
            message = @"In this game, you want to connect the circuit and power up the bulb by clicking on switches to correct positions.";
            break;
        case 1:
            title = @"Instrucción";
            message = @"En ese juego, estás tratando de conectar la circuito y encender la bombilla haciendo clic en los interruptores a las posiciones correctas";
            break;
        case 2:
            title = @"游戏指南";
            message = @"在这个游戏中，你需要通过变换开关的位置使灯泡发亮。";
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueToGame"]) {
        GameViewController *vc = [segue destinationViewController];
        
        [vc setLanguage:language];
    }
}

@end
