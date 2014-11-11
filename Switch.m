//
//  Switch.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Switch.h"

@implementation Switch {
    UIButton* _switch;
    NSArray* _possibleOrientations;
    int _currentOrientation;
    int _row;
    int _col;
}

- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col
{
    self = [super initWithFrame:frame];
    
    // TODO: add LRTB.png
    _row = row;
    _col = col;
    _possibleOrientations = [[NSArray alloc] initWithObjects:@"XXXX",@"LXXX",@"LRXX",@"LRTX",@"LRTB",@"LRXB",@"LXTX",@"LXTB",@"LXXB",@"XRXX",@"XRTX",@"XRTB",@"XRXB",@"XXTX",@"XXTB",@"XXXB", nil];
    _currentOrientation = 0;

    CGRect switchFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _switch = [[UIButton alloc] initWithFrame:switchFrame];
    [_switch setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat: @"wire%@", _possibleOrientations[_currentOrientation]]] forState:UIControlStateNormal];
    [_switch addTarget:self action:@selector(switchSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switch];

    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor redColor].CGColor];
    
    return self;
}

- (void) switchSelected
{
    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    NSString* orientation = [self rotateSwitch];

    [self.delegate performSelector:@selector(switchSelectedAtPosition:WithOrientation:) withObject:position withObject:orientation];
}

- (NSString*) rotateSwitch
{
    if (_currentOrientation == [_possibleOrientations count]-1) {
        _currentOrientation = 0;
    } else {
        ++_currentOrientation;
    }
    [_switch setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"wire%@", _possibleOrientations[_currentOrientation]]] forState:UIControlStateNormal];
    
    return _possibleOrientations[_currentOrientation];
}

@end