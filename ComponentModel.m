//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "ComponentModel.h"

@interface ComponentModel()
{
}

@end

@implementation ComponentModel


#pragma mark - Initialization

/*
 * Initialize Component Model
 * Input: Row, Col, and State info
 * Output: The initialized object
 */
- (id) initType:(enum COMPONENTS)newType AtRow:(int)row AndCol:(int)col WithState:(BOOL)state {
    if (self = [super init]) {
        self.row = row;
        self.col = col;
        self.state = state;
        self.type = newType;
        self.direction = NONE;
    }

    return self;
}

#pragma mark - Public Methods

- (NSString*) getConnections {
    
    NSString *connections = @"";
    if (self.connectedLeft) {
        connections = [connections stringByAppendingString:@"L"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if (self.connectedRight) {
        connections = [connections stringByAppendingString:@"R"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if (self.connectedTop) {
        connections = [connections stringByAppendingString:@"T"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    if (self.connectedBottom) {
        connections = [connections stringByAppendingString:@"B"];
    } else {
        connections = [connections stringByAppendingString:@"X"];
    }
    
    return connections;
}

@end