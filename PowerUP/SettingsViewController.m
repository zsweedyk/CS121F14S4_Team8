//
//  SettingsViewController.m
//  PowerUP
//
//  Created by CS121 on 12/5/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "SettingsViewController.h"
#import "MenuViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SettingsViewController (){
    // sounds
    AVAudioPlayer *_audioPlayerLanguagePressed;
    
    // language control and buttons
    UISegmentedControl *_segmentControl;
    IBOutlet UIImageView *background;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // set up sounds, segmented control, and buttons
    [self setUpSounds];
    [self setUpSegControl];
    [self setBackground];
}

- (void) setUpSounds
{
    NSString *languagePath  = [[NSBundle mainBundle] pathForResource:@"beep-attention" ofType:@"aif"];
    NSURL *languagePathURL  = [NSURL fileURLWithPath : languagePath];
    _audioPlayerLanguagePressed = [[AVAudioPlayer alloc] initWithContentsOfURL:languagePathURL error:nil];
}

- (void) setUpSegControl
{
    CGFloat frameWidth   = self.view.frame.size.width;
    CGFloat frameHeight  = self.view.frame.size.height;
    CGFloat buttonWidth  = frameWidth / 2;
    CGFloat buttonHeight = buttonWidth / 3;
    
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"English",@"español",@"中文"]];
    [_segmentControl setTintColor:[UIColor colorWithRed:0 green:251/255.0 blue:175/255.0 alpha:1]];
    _segmentControl.frame = CGRectMake((frameWidth - buttonWidth) / 2, (frameHeight - buttonHeight * 6), buttonWidth, buttonHeight / 2);
    [_segmentControl setSelectedSegmentIndex:self.mainLanguage];
    [_segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentControl];
}

- (void) setBackground
{
    switch (self.mainLanguage) {
        case ENGLISH:
            [background setImage:[UIImage imageNamed:@"BGsettings.png"]];
            break;
            
        case SPANISH:
            [background setImage:[UIImage imageNamed:@"BGsettingsSP.png"]];
            break;
            
        case CHINESE:
            [background setImage:[UIImage imageNamed:@"BGsettingsCH.png"]];
            break;
            
        default:
            break;
    }
}

/*
 *  Set the language based on the value of segcontrol
 *  Note that english - 0, spanish - 1, chinese -2
 */
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    [_audioPlayerLanguagePressed prepareToPlay];
    [_audioPlayerLanguagePressed play];
    
    // change the language and title of the buttons
    [self changeButtonLanguage:segment.selectedSegmentIndex];
}

/*
 *  Change the display title of buttons according to different language
 */
- (void) changeButtonLanguage: (NSInteger) choice
{
    switch (choice) {
        case ENGLISH:
            self.mainLanguage = ENGLISH;
            [self setBackground];
            break;
            
        case SPANISH:
            self.mainLanguage = SPANISH;
            [self setBackground];
            break;
            
        case CHINESE:
            self.mainLanguage = CHINESE;
            [self setBackground];
            break;
            
        default:
            break;
    }
}

/*
 *  Pass data to main viewcontroller or game viewcontroller
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"settingToMain"]) {
        MenuViewController *destViewController = segue.destinationViewController;
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.locks        = self.locks;
        destViewController.currentState = self.currentState;
    }
}



@end
