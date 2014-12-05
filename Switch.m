//
//  Switch.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Switch.h"

@implementation Switch {
    UIImageView* _switch;
    NSString* _orientation;
    NSString* _imageOrientation;
    int _row;
    int _col;
}

- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col
{
    self = [super initWithFrame:frame];
    // Initialize fields for touch interaction
    self._exitedDir = @"X";
    self._enteredDir = @"X";
    
    _row = row;
    _col = col;
    
    CGRect switchFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _switch = [[UIImageView alloc] initWithFrame:switchFrame];
    
    [self resetDirection];
    [self addSubview:_switch];
    
    return self;
}

- (void) addImageDirection: (NSString*) dir
{
    _imageOrientation = [self addOrientation:dir to:_imageOrientation];
    _switch.image = [UIImage imageNamed:[NSString stringWithFormat: @"switch%@on", _imageOrientation]];
}

- (void) removeImageDirection: (NSString*) dir
{
    _imageOrientation = [_imageOrientation stringByReplacingOccurrencesOfString:dir withString:@"X"];
    _switch.image = [UIImage imageNamed:[NSString stringWithFormat: @"switch%@on", _imageOrientation]];
}

- (void) addDirection: (NSString*) dir
{
    _orientation = [self addOrientation:dir to:_orientation];
    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    [self.delegate performSelector:@selector(switchSelectedAtPosition:WithOrientation:) withObject:position withObject:_orientation];
    
    //These lines may not be necesarry
    _imageOrientation = _orientation;
    _switch.image = [UIImage imageNamed:[NSString stringWithFormat: @"switch%@on", _imageOrientation]];
}

- (void) resetDirection
{
    _orientation = @"XXXX";
    _imageOrientation = @"XXXX";
    NSArray* position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    [self.delegate performSelector:@selector(switchSelectedAtPosition:WithOrientation:) withObject:position withObject:_orientation];
    _switch.image = [UIImage imageNamed:[NSString stringWithFormat: @"switch%@on", _imageOrientation]];
}

- (NSString*) addOrientation: (NSString*) dir to: (NSString*) currOrientation
{
    NSString* newOrientation;
    NSString* start;
    NSString* end;
    if ([dir isEqual:@"L"]) {
        start = @"";
        end = [currOrientation substringFromIndex:1];
    } else if ([dir isEqual:@"R"]) {
        start = [currOrientation substringToIndex:1];
        end = [currOrientation substringFromIndex:2];
    } else if ([dir isEqual:@"T"]) {
        start = [currOrientation substringToIndex:2];
        end = [currOrientation substringFromIndex:3];
    } else if ([dir isEqual:@"B"]) {
        start = [currOrientation substringToIndex:3];
        end = @"";
    }
    newOrientation = [NSString stringWithFormat:@"%@%@%@", start, dir, end];
    return newOrientation;
}



@end