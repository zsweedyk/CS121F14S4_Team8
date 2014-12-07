//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "ComponentModel.h"

@interface ComponentModel()
{
    int _row;
    int _col;
    NSString *_type;
    BOOL _state;
    NSString *_direction;
    BOOL _connectedTop;
    BOOL _connectedBottom;
    BOOL _connectedRight;
    BOOL _connectedLeft;
    
}

@end

@implementation ComponentModel


# pragma mark Public Methods


/*
 * Initialize Component Model
 * Input: Row, Col, and State info
 * Output: The initialized object
 */
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


/*
 * Get the direction of a component
 * Input: N/A
 * Output: the direction of the component
 */
- (NSString*) getDirection
{
    NSAssert(_direction, @"Direction still hasn't been initialized");
    NSAssert([_type isEqual:@"receiver"]||[_type isEqual:@"emitter"], @"Component type of %@ does not have direction", _type);
    return _direction;
}


/*
 * Set the direction of component
 * Input: The direction for the component
 * Output: N/A
 */
- (void) pointTo:(NSString *)dir
{
    _direction = dir;
}


/*
 * Set the connection of the component to the right
 * Input: A boolean, true if the component is connected to the component to its right
 * Output: N/A
 */
- (void) connectedRight:(BOOL)connection
{
    _connectedRight = connection;
}


/*
 * Set the connection of the component to the top
 * Input: A boolean, true if the component is connected to the component to its top
 * Output: N/A
 */
- (void) connectedTop:(BOOL)connection
{
    _connectedTop = connection;
}


/*
 * Set the connection of the component to the bottom
 * Input: A boolean, true if the component is connected to the component to its bottom
 * Output: N/A
 */
- (void) connectedBottom:(BOOL)connection
{
    _connectedBottom = connection;
}


/*
 * Set the connection of the component to the left
 * Input: A boolean, true if the component is connected to the component to its left
 * Output: N/A
 */
- (void) connectedLeft:(BOOL)connection
{
    _connectedLeft = connection;
}


/*
 * Get the type of the component
 * Input: N/A
 * Output: the type of the component
 */
- (NSString *) getType
{
    return _type;
}


/*
 * Get the state of the component
 * Input: N/A
 * Output: a boolean, yes if the state is on
 */
- (BOOL) getState
{
    return _state;
}


/*
 * Set the state of the component
 * Input: A boolean, true if the component is turned on
 * Output: N/A
 */
- (void) setState:(BOOL)state
{
    _state = state;
}


/*
 * Get the row location of the component
 * Input: N/A
 * Output: the row index
 */
- (int) getRow
{
    return _row;
}


/*
 * Get the col location of the component
 * Input: N/A
 * Output: the col index
 */
- (int) getCol
{
    return _col;
}


/*
 * Find out if the component is connected to its right
 * Input: N/A
 * Output: a boolean, true if the component is connected to its right
 */
- (BOOL) isConnectedRight
{
    return _connectedRight;
}


/*
 * Find out if the component is connected to its top
 * Input: N/A
 * Output: a boolean, true if the component is connected to its top
 */
- (BOOL) isConnectedTop
{
    return _connectedTop;
}


/*
 * Find out if the component is connected to its bottom
 * Input: N/A
 * Output: a boolean, true if the component is connected to its bottom
 */
- (BOOL) isConnectedBottom
{
    return _connectedBottom;
}


/*
 * Find out if the component is connected to its left
 * Input: N/A
 * Output: a boolean, true if the component is connected to its left
 */
- (BOOL) isConnectedLeft
{
    return _connectedLeft;
}


/*
 * Find out if the component is the same component as a specified other component
 * Input: Another Component Model
 * Output: a boolean, true if the component is the same as the input 
 */
- (BOOL) isSameComponentAs:(ComponentModel*)otherComp
{
    return (_row == [otherComp getRow] && _col == [otherComp getCol] && [_type isEqual:[otherComp getType]]);
}

@end