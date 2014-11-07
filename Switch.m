//
//  Switch.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Switch.h"

@implementation Switch {
    NSArray* _possibleOrientations;
    int _currentOrientation;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    // TODO: add LRTB.png
    _possibleOrientations = [[NSArray alloc] initWithObjects:@"XXXX",@"LXXX",@"LRXX",@"LRTX",@"LRTB",@"LRXB",@"LXTX",@"LXTB",@"LXXB",@"XRXX",@"XRTX",@"XRTB",@"XRXB",@"XXTX",@"XXTB",@"XXXB", nil];
    _currentOrientation = 0;
    
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat: @"wire%@", _possibleOrientations[_currentOrientation]]] forState:UIControlStateNormal];
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor redColor].CGColor];
    [self addTarget:self.delegate action:@selector(switchSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}


- (NSString*) rotateSwitch
{
    if (_currentOrientation == [_possibleOrientations count]-1) {
        _currentOrientation = 0;
    } else {
        ++_currentOrientation;
    }
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"wire%@", _possibleOrientations[_currentOrientation]]] forState:UIControlStateNormal];
    
    return _possibleOrientations[_currentOrientation];
}

@end