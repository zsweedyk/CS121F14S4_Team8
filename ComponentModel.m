//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "ComponentModel.h"

@interface ComponentModel()
{
    int _row;
    int _col;
    BOOL _state;
    
    BOOL _connectedTop;
    BOOL _connectedBottom;
    BOOL _connectedRight;
    BOOL _connectedLeft;
    
}

@end

@implementation ComponentModel


#pragma mark - Initialization

/*
 * Initialize Component Model
 * Input: Row, Col, and State info
 * Output: The initialized object
 */
- (id) initAtRow:(int)row AndCol:(int)col WithState:(BOOL)state
{
    if (self = [super init]) {
        _row = row;
        _col = col;
        _state = state;
    }

    return self;
}

@end