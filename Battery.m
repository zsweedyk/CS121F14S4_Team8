//
//  Battery.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Battery.h"
#import "ExplosionScene.h"

@implementation Battery{

    UIButton* _battery;
    int row;
    int col;
}

#pragma mark - Initialization

- (id) initWithFrame:(CGRect)frame AtRow:(int)initRow AndCol:(int)initCol AndPolarity:(BOOL)pos WithConnections:(NSString*)connections {
    
    self = [super initWithFrame:frame];
    
    row = initRow;
    col = initCol;
    
    [self setUpNameWithPolarity:pos AndConnections:connections];
    [self setUpButton];
    
    return self;
}

#pragma mark - Public Methods

- (int) getPosition {
    return 100  *row + col;
}

#pragma mark - Private Methods

- (void) setUpNameWithPolarity:(BOOL)pos AndConnections:(NSString*)connections {
    NSString *polarity;
    if (pos) {
        polarity = @"Pos";
    } else {
        polarity = @"Neg";
    }
    self.imageName = [NSString stringWithFormat:@"battery%@%@", polarity, connections];
}

- (void) setUpButton {
    
    CGRect battFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _battery = [[UIButton alloc] initWithFrame:battFrame];
    [_battery setBackgroundImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
    
    [_battery addTarget:self.delegate action:@selector(powerUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_battery];
}

@end
