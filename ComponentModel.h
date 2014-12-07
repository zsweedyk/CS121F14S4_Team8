//
// Created by Sean on 11/7/14.
// Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ComponentModel : NSObject

- (id) initAtRow:(int)row AndCol:(int)col WithState:(BOOL)state;

@property(nonatomic, readwrite) BOOL connectedRight;
@property(nonatomic, readwrite) BOOL connectedLeft;
@property(nonatomic, readwrite) BOOL connectedTop;
@property(nonatomic, readwrite) BOOL connectedBottom;

@property(nonatomic, readwrite) BOOL state;

@property(nonatomic, readwrite) int row;
@property(nonatomic, readonly) int col;

@end