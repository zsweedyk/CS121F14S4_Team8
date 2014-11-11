//
//  Deflector.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Deflector.h"

@implementation Deflector
{
    NSArray* _possibleOrientations;
    int _currentOrientation;
    NSString* name;
   
    int _row;
    int _col;
    
    UIButton* _deflector;
}


- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col;
{
    self = [super initWithFrame:frame];
    
    _row = row;
    _col = col;
    
    _possibleOrientations = [[NSArray alloc] initWithObjects:@"XRTX",@"XRXB",@"LXXB",@"LXTX",nil];
    _currentOrientation = 0;
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
    
    CGRect deflectorFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _deflector = [[UIButton alloc] initWithFrame:deflectorFrame];
    [_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [_deflector addTarget:self action:@selector(deflectorSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deflector];
    
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor yellowColor].CGColor];
    
    return self;
}

- (void) deflectorSelected
{
    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    NSString* orientation = [self rotateDeflector];
    
    [self.delegate performSelector:@selector(deflectorSelectedAtPosition:WithOrientation:) withObject:position withObject:orientation];
}

- (NSString*) rotateDeflector
{
    if (_currentOrientation == [_possibleOrientations count]-1) {
        _currentOrientation = 0;
    } else {
        ++_currentOrientation;
    }
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
    
    [_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    return _possibleOrientations[_currentOrientation];
}

- (void) turnOn
{
    NSString* onName = [name stringByAppendingString:@"on"];
    
    [_deflector setBackgroundImage:[UIImage imageNamed:onName] forState:UIControlStateNormal];
    
}

- (void) turnOff
{
    [_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}


@end

