//
//  BatteryModel.m
//  PowerUP
//
//  Created by Sean on 12/6/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "BatteryModel.h"

@interface BatteryModel () {
    enum POLARITY {
        POSITIVE,
        NEGATIVE
    };
    
    enum POLARITY polarity;
}

@end

@implementation BatteryModel

- (id) initAtRow:(int)row AndCol:(int)col WithState:(BOOL)state Positive:(BOOL)pos {
    
    self = [super initAtRow:row AndCol:col WithState:state];
    
    if (pos) {
        polarity = POSITIVE;
    } else {
        polarity = NEGATIVE;
    }
    
    return self;
}

@end
