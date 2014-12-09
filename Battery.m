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
<<<<<<< HEAD

    UIButton* _battery;
    int row;
    int col;
}

#pragma mark - Initialization
=======
    NSString *_name;
    UIButton *_battery;
    int _row;
    int _col;
}

- (id) initWithFrame:(CGRect)frame andOrientation:(NSString*) name AtRow:(int)row AndCol:(int)col
{
    self = [super initWithFrame:frame];
    _name = name;
    _row = row;
    _col = col;

    CGRect battFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _battery = [[UIButton alloc] initWithFrame:battFrame];
    [_battery setBackgroundImage:[UIImage imageNamed:_name] forState:UIControlStateNormal];
    [_battery addTarget:self.delegate action:@selector(powerUp:) forControlEvents:UIControlEventTouchUpInside];
>>>>>>> PowerUP

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

<<<<<<< HEAD
- (void) setUpButton {
    
    CGRect battFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _battery = [[UIButton alloc] initWithFrame:battFrame];
    [_battery setBackgroundImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
    
    [_battery addTarget:self.delegate action:@selector(powerUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_battery];
=======
- (void) exploded
{
    NSString *newName = [NSString stringWithFormat:@"%@%@", _name, @"short"];
    [_battery setBackgroundImage:[UIImage imageNamed:newName] forState:UIControlStateNormal];
>>>>>>> PowerUP
}

- (int) getRow
{
    return _row;
}

- (int) getCol
{
    return _col;
}

@end
