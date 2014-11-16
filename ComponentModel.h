//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ComponentModel : NSObject

- (id) initOfType:(NSString*)type AtRow:(int)row AndCol:(int)col AndState:(NSString*)state;
- (void) connectedRight:(bool)connection;
- (void) connectedTop:(bool)connection;
- (void) connectedBottom:(bool)connection;
- (void) connectedLeft:(bool)connection;
- (NSString*) getType;
- (NSString*) getState;
- (void) setState:(NSString*)state;
- (int) getRow;
- (int) getCol;
- (bool) isConnectedRight;
- (bool) isConnectedTop;
- (bool) isConnectedBottom;
- (bool) isConnectedLeft;
- (bool) isSameComponentAs:(ComponentModel*)otherComp;
- (void) pointTo:(NSString *)dir;
- (NSString*)direction;

@end