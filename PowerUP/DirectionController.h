//
//  DirectionController.h
//  PowerUP
//
//  Created by Daniel Cogan on 11/9/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectionControllerDelegate
@required

- (void) rotateDeflector:(int)dir;
- (void) changeImage: (NSString*) dir;
- (void) onTap;

@end

@interface DirectionController : UIControl

@property (nonatomic, strong) id delegate;

@end