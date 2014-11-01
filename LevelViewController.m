//
//  LevelViewController.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "LevelViewController.h"
#import "GameViewController.h"

@interface LevelViewController () {
    NSMutableArray* _buttons;
    int levels;
}

@end

@implementation LevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    levels = 3;
    _buttons = [[NSMutableArray alloc] init];
    
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat buttonWidth = frameWidth / 2;
    CGFloat buttonHeight = buttonWidth / 3;
    CGFloat buttonSpace = frameHeight / (levels * 2);
    
    for (int i = 0; i < levels; i++){
        CGFloat x = (frameWidth - buttonWidth) / 2;
        CGFloat y = buttonSpace + buttonSpace * i;
        CGRect buttonFrame = CGRectMake(x, y, buttonWidth, buttonHeight);
        
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        button.tag = i;
        
        [button setBackgroundColor:[UIColor blueColor]];
        [button setTitle:[NSString stringWithFormat:@"Level %d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        [_buttons addObject:button];
        
        [button addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Do any additional setup after loading the view.
}

- (void)cellSelected:(id)sender
{
    UIButton* button = (UIButton*) sender;
    int buttonTag = (int) button.tag;
    
    GameViewController* gameVC = [[GameViewController alloc] initWithLevel:buttonTag];
    [self presentViewController:gameVC animated:NO completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueToGame"]) {
        GameViewController *vc = [segue destinationViewController];
        
        [self presentViewController:vc animated:YES completion:nil];
        //[vc setLanguage:language];
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
