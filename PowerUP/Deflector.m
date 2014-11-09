//
//  Deflector.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014年 CS121F14S4_Team8. All rights reserved.
//

#import "Deflector.h"

@implementation Deflector
{
    NSArray* _possibleOrientations;
    int _currentOrientation;
    NSString* name;
    NSString* onName;
    int _row;
    int _col;
    UIButton* _deflector;
    //BOOL on;
}


- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col;
{
    self = [super initWithFrame:frame];
    
    _row = row;
    _col = col;
    
    _possibleOrientations = [[NSArray alloc] initWithObjects:@"XRTX",@"XRXB",@"LXXB",@"LXTX",nil];
    _currentOrientation = 0;
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
    onName = [name stringByAppendingString:@"on"];
    
    CGRect deflectorFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _deflector = [[UIButton alloc] initWithFrame:deflectorFrame];
    [_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [_deflector addTarget:self action:@selector(deflectorSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deflector];
    
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor yellowColor].CGColor];
    
    /*[self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]]] forState:UIControlStateNormal];
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor redColor].CGColor];
    [self addTarget:self.delegate action:@selector(deflectorSelected:) forControlEvents:UIControlEventTouchUpInside];*/
    
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
    onName = [name stringByAppendingString:@"on"];
    /*[self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"deflector%@", _possibleOrientations[_currentOrientation]]] forState:UIControlStateNormal];
    
    //on = NO;
    
    return _possibleOrientations[_currentOrientation];*/
    [_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    return _possibleOrientations[_currentOrientation];
}

- (void) turnOn
{
    //NSLog(@"turnOn");
    //if(!on){
    [_deflector setBackgroundImage:[UIImage imageNamed:onName] forState:UIControlStateNormal];
    //on = YES;
    //}
    
}

- (void) turnOff
{
    //if(on){
    [_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    //on = NO;
    //}
}


@end

