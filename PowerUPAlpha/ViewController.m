//
//  ViewController.m
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSInteger language;
    // 0 english
    // 1 spanish
    // 2 chinese
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    language = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)indexChanged:(UISegmentedControl *)sender
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"english");
            language = 0;
            [self.level setTitle:@"Start New Game" forState:UIControlStateNormal];
            [self.about setTitle:@"How to Play" forState:UIControlStateNormal];
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

@end
