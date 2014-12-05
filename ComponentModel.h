//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ComponentModel : NSObject

- (id) initOfType:(NSString*)type AtRow:(int)row AndCol:(int)col AndState:(BOOL)state;
- (void) connectedRight:(BOOL)connection;
- (void) connectedTop:(BOOL)connection;
- (void) connectedBottom:(BOOL)connection;
- (void) connectedLeft:(BOOL)connection;
- (void) setState:(BOOL)state;
- (void) pointTo:(NSString *)dir;

- (NSString*) getType;
- (BOOL) getState;
- (int) getRow;
- (int) getCol;
- (NSString*) getDirection;
- (BOOL) isConnectedRight;
- (BOOL) isConnectedTop;
- (BOOL) isConnectedBottom;
- (BOOL) isConnectedLeft;
- (BOOL) isSameComponentAs:(ComponentModel*)otherComp;

@end