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
    BOOL _state;
    NSString* _direction;
    BOOL _connectedTop;
    BOOL _connectedBottom;
    BOOL _connectedRight;
    BOOL _connectedLeft;
    
}

@end

@implementation ComponentModel

- (id) initOfType:(NSString*)type AtRow:(int)row AndCol:(int)col AndState:(BOOL)state
{
    if (self = [super init]) {
        _row = row;
        _col = col;
        _type = type;
        _state = state;
    }

    return self;
}

- (NSString*) getDirection
{
    NSAssert(_direction, @"Direction still hasn't been initialized");
    NSAssert([_type isEqual:@"Receiver"]||[_type isEqual:@"Emitter"], @"Component type of %@ does not have direction", _type);
    return _direction;
}

- (void) pointTo:(NSString *)dir
{
    // We allow empty because it makes initialization easier
    //NSAssert([_type isEqual:@"Receiver"]||[_type isEqual:@"Emitter"]||[_type isEqual:@"Empty"], @"Component type of %@ does not point", _type);
    _direction = dir;
}

- (void) connectedRight:(BOOL)connection
{
    _connectedRight = connection;
}

- (void) connectedTop:(BOOL)connection
{
    _connectedTop = connection;
}

- (void) connectedBottom:(BOOL)connection
{
    _connectedBottom = connection;
}

- (void) connectedLeft:(BOOL)connection
{
    _connectedLeft = connection;
}

- (NSString *) getType
{
    return _type;
}

- (BOOL) getState
{
    return _state;
}

- (void) setState:(BOOL)state
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

- (BOOL) isConnectedRight
{
    return _connectedRight;
}

- (BOOL) isConnectedTop
{
    return _connectedTop;
}

- (BOOL) isConnectedBottom
{
    return _connectedBottom;
}

- (BOOL) isConnectedLeft
{
    return _connectedLeft;
}

- (BOOL) isSameComponentAs:(ComponentModel*)otherComp
{
    return (_row == [otherComp getRow] && _col == [otherComp getCol] && [_type isEqual:[otherComp getType]]);
}

@end