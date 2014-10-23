//
//  GameViewController.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = self.view.frame;
    
    // set up T button
    CGFloat yButton = CGRectGetHeight(frame) * 0.6;
    CGFloat xButtonT = CGRectGetWidth(frame) * 0.1;
    CGFloat TButtonSize = xButtonT * 2;
    CGFloat xButtonB = (xButtonT * 3 + TButtonSize * 2);
    CGFloat BButtonSize = TButtonSize;
    
    CGRect TFrame = CGRectMake(xButtonT, yButton, TButtonSize, TButtonSize / 2);
    UIButton* T = [[UIButton alloc] initWithFrame:TFrame];
    T.layer.cornerRadius = TButtonSize / 10;
    T.layer.borderWidth = 1.0f;
    [T setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [T setTitle:@"Top On" forState:UIControlStateNormal];
    [T setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    T.titleLabel.font = [UIFont systemFontOfSize:TButtonSize/5];
    [self.view addSubview:T];

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
