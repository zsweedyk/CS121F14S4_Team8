//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "ComponentModel.h"

@interface ComponentModel()
{
    int _row;
    int _col;
    NSString* _type;
    NSString* _state;
    NSString* _direction;
    bool _connectedTop;
    bool _connectedBottom;
    bool _connectedRight;
    bool _connectedLeft;
}
@end

@implementation ComponentModel

- (id) initOfType:(NSString*)type AtRow:(int)row AndCol:(int)col AndState:(NSString*)state
{
    if (self = [super init]) {
        _row = row;
        _col = col;
        _type = type;
        _state = state;
    }

    return self;
}
- (NSString*)direction
{
    return _direction;
}

- (void) pointTo:(NSString *)dir
{
    _direction = dir;
}

- (void) connectedRight:(bool)connection
{
    _connectedRight = connection;
}

- (void) connectedTop:(bool)connection
{
    _connectedTop = connection;
}

- (void) connectedBottom:(bool)connection
{
    _connectedBottom = connection;
}

- (void) connectedLeft:(bool)connection
{
    _connectedLeft = connection;
}

- (NSString *) getType
{
    return _type;
}

- (NSString *) getState
{
    return _state;
}

- (void) setState:(NSString*)state
{
    _state = state;
}

- (int) getRow
{
    return _row;
}

- (int) getCol
{
    return _col;
}

- (bool) isConnectedRight
{
    return _connectedRight;
}

- (bool) isConnectedTop
{
    return _connectedTop;
}

- (bool) isConnectedBottom
{
    return _connectedBottom;
}

- (bool) isConnectedLeft
{
    return _connectedLeft;
}

- (bool) isSameComponentAs:(ComponentModel*)otherComp
{
    return (_row == [otherComp getRow] && _col == [otherComp getCol] && [_type isEqual:[otherComp getType]]);
}

@end