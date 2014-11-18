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
    NSArray* _twoWays;
    NSArray* _threeWays;
    NSArray* _fourWays;
    int _currentOrientation;
    NSString* name;
    NSString* _orientation;
    int _currentType;
    
    int _row;
    int _col;
    
    UIImageView* _deflector;
    DirectionController* control;
    NSString* previousDir;
}


- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col;
{
    self = [super initWithFrame:frame];
    
    //set previous direction to X if user drags the deflector for the first time
    previousDir = @"X";
    
    _row = row;
    _col = col;
    
    _twoWays = [[NSArray alloc] initWithObjects:@"XRTX",@"XRXB",@"LXXB",@"LXTX",nil];
    _threeWays = [[NSArray alloc] initWithObjects:@"LRTX",@"XRTB",@"LRXB",@"LXTB", nil];
    _fourWays = [[NSArray alloc] initWithObjects:@"LRTB", nil];
    _possibleOrientations = _twoWays;
    _currentType = 2;
    _currentOrientation = 0;
    _orientation = _possibleOrientations[_currentOrientation];
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
    
    CGRect deflectorFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _deflector = [[UIImageView alloc] initWithFrame:deflectorFrame];
    _deflector.image = [UIImage imageNamed:name];
    control = [[DirectionController alloc] initWithFrame:deflectorFrame];
    control.delegate = self;
    
    [self addSubview:_deflector];
    [self addSubview:control];
    
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor yellowColor].CGColor];
    
    return self;
}
//switch to other deflector types on tap
- (void) onTap
{
    if(_currentType == 2){
        _possibleOrientations = _threeWays;
        _currentType = 3;
    }else if(_currentType == 3){
        _possibleOrientations = _fourWays;
        _currentType = 4;
    }else if(_currentType == 4){
        _possibleOrientations = _twoWays;
        _currentType = 2;
    }
    _currentOrientation = 0;
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
    _deflector.image = [UIImage imageNamed:name];
    _orientation = _possibleOrientations[_currentOrientation];
    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    previousDir = @"X";
    [self.delegate performSelector:@selector(deflectorSelectedAtPosition:WithOrientation:) withObject:position withObject:_orientation];
    
}

//0 for clockwise, 1 for counterclockwise, 2 for oppositeDirection
- (void) rotateDeflector:(int)dir
{
    if(_currentType != 4){
        if(dir == 0){
            if (_currentOrientation == [_possibleOrientations count]-1) {
                _currentOrientation = 0;
            } else {
                ++_currentOrientation;
            }
        }else if(dir == 1){
            if (_currentOrientation == 0){
                _currentOrientation = [_possibleOrientations count] - 1;
            } else {
                --_currentOrientation;
            }
        }else{
            if (_currentOrientation == [_possibleOrientations count]-2) {
                _currentOrientation = 0;
            } else if(_currentOrientation == [_possibleOrientations count]-1){
                _currentOrientation = 1;
            }else {
                _currentOrientation = _currentOrientation+2;
            }
        }
    }
    
    
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
    
    //[_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal]
    _deflector.image = [UIImage imageNamed:name];
    _orientation = _possibleOrientations[_currentOrientation];
    
    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    previousDir = @"X";
    [self.delegate performSelector:@selector(deflectorSelectedAtPosition:WithOrientation:) withObject:position withObject:_orientation];
    
    //return _possibleOrientations[_currentOrientation];
}

- (void) changeDirection:(NSString *)dir
{
    //_orientation = [self newOrientation:dir];
    //    NSLog(_orientation);
    //    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    //    previousDir = @"X";
    //    [self.delegate performSelector:@selector(deflectorSelectedAtPosition:WithOrientation:) withObject:position withObject:_orientation];
}

- (void) changeImage:(NSString *)dir
{
    [self newOrientation:dir];
}

-(void) newOrientation:(NSString*)dir
{
    //NSString* orientation;
    if ([previousDir isEqual:@"R"]){
        if([dir isEqual:@"T"]){
            [self rotateDeflector:1];
        }else if([dir isEqual:@"B"]){
            [self rotateDeflector:0];
        }else if([dir isEqual:@"L"]){
            [self rotateDeflector:2];
        }
    }else if ([previousDir isEqual:@"L"]){
        if([dir isEqual:@"B"]){
            [self rotateDeflector:1];
        }else if([dir isEqual:@"T"]){
            [self rotateDeflector:0];
        }else if([dir isEqual:@"R"]){
            [self rotateDeflector:2];
        }
    }else if ([previousDir isEqual:@"T"]){
        if([dir isEqual:@"L"]){
            [self rotateDeflector:1];
        }else if([dir isEqual:@"R"]){
            [self rotateDeflector:0];
        }else if([dir isEqual:@"B"]){
            [self rotateDeflector:2];
        }
    }else if ([previousDir isEqual:@"B"]){
        if([dir isEqual:@"R"]){
            [self rotateDeflector:1];
        }else if([dir isEqual:@"L"]){
            [self rotateDeflector:0];
        }else if([dir isEqual:@"T"]){
            [self rotateDeflector:2];
        }
    }
    previousDir = dir;
    //NSLog(orientation);
    //return orientation;
}

- (void) turnOn
{
    NSString* onName = [name stringByAppendingString:@"on"];
    
    //[_deflector setBackgroundImage:[UIImage imageNamed:onName] forState:UIControlStateNormal];
    _deflector.image = [UIImage imageNamed:onName];
    
}

- (void) turnOff
{
    //[_deflector setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    _deflector.image = [UIImage imageNamed:name];
}


@end