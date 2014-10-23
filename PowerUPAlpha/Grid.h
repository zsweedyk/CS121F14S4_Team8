//
//  Grid.h
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Grid : UIView

- (id) initWithFrame:(CGRect)frame size:(CGFloat) frameSize;
- (void)setValueAtRow:(int) row col:(int)col to:(NSString*) value;

@end
