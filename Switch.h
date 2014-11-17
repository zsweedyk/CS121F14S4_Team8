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
@property NSString* _enteredDir;
@property NSString* _exitedDir;

- (id) initWithFrame:(CGRect)frame AtRow:(int)row AndCol:(int) col;
- (void) addImageDirection: (NSString*) dir;
- (void) removeImageDirection: (NSString*) dir;
- (void) addDirection: (NSString*) dir;
- (void) resetDirection;

@end
