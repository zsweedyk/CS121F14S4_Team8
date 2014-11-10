//
//  Switch.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Switch.h"
#import "DirectionController.h"

@implementation Switch {
    UIImageView* _switch;
    DirectionController* control;
    NSString* _currentOrientation;
    int _row;
    int _col;
}

- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col
{
    self = [super initWithFrame:frame];
    
    // TODO: add LRTB.png
    _row = row;
    _col = col;
    _currentOrientation = @"XXXX";

    CGRect switchFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _switch = [[UIImageView alloc] initWithFrame:switchFrame];
    _switch.image = [UIImage imageNamed:[NSString stringWithFormat: @"wire%@", _currentOrientation]];
    control = [[DirectionController alloc] initWithFrame:switchFrame];
    control.delegate = self;
    
    [self addSubview:_switch];
    [self addSubview:control];

    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[UIColor redColor].CGColor];
    
    return self;
}

- (void) changeDirection: (NSString*) dir
{
    _currentOrientation = [self newOrientation:dir];
    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    [self.delegate performSelector:@selector(switchSelectedAtPosition:WithOrientation:) withObject:position withObject:_currentOrientation];
    _switch.image = [UIImage imageNamed:[NSString stringWithFormat: @"wire%@", _currentOrientation]];
    
}

- (void) changeImage: (NSString*) dir
{
    _switch.image = [UIImage imageNamed:[NSString stringWithFormat: @"wire%@", [self newOrientation:dir]]];
    
}

- (NSString*) newOrientation: (NSString*) dir
{
    NSString* newOrientation;
    if ([_currentOrientation containsString:dir]) {
        newOrientation = [_currentOrientation stringByReplacingOccurrencesOfString:dir withString:@"X"];
    } else {
        NSString* start;
        NSString* end;
        if ([dir isEqual:@"L"]) {
            start = @"";
            end = [_currentOrientation substringFromIndex:1];
        } else if ([dir isEqual:@"R"]) {
            start = [_currentOrientation substringToIndex:1];
            end = [_currentOrientation substringFromIndex:2];
        } else if ([dir isEqual:@"T"]) {
            start = [_currentOrientation substringToIndex:2];
            end = [_currentOrientation substringFromIndex:3];
        } else if ([dir isEqual:@"B"]) {
            start = [_currentOrientation substringToIndex:3];
            end = @"";
        }
        newOrientation = [NSString stringWithFormat:@"%@%@%@", start, dir, end];
    }
    return newOrientation;
}



@end