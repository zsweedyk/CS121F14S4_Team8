//
//  Deflector.h
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeflectorDelegate
@required
- (void) deflectorSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)orientation;
@end
@interface Deflector : UIButton

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col;
- (NSString*) rotateDeflector;
- (void) turnOn;
- (void) turnOff;

@end
