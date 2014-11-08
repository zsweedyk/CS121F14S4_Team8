//
//  Switch.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SwitchDelegate
@required

- (void) switchSelectedAtPosition:(NSArray*)position WithOrientation:(NSString*)orientation;

@end

@interface Switch : UIView

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col;
- (NSString*) rotateSwitch;

@end
