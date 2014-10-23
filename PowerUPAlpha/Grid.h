//
//  Grid.h
//  PowerUPAlpha
//
//  Created by Cyrus Huang on 10/22/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Switch.h"

@protocol GridDelegate

@required
- (void) switchSelectedWithTag:(NSNumber*)tag withOrientation:(NSString*)newOrientation;
@end


@interface Grid : UIView <SwitchDelegate>

@property (nonatomic, strong) id delegate;

- (id) initWithFrame:(CGRect)frame andNumRows:(int)rows andCols:(int)cols;
- (void) setUpGridForNumRows:(int)rows andCols:(int)cols;
- (void) setValueAtRow:(int) row col:(int)col to:(NSString*) value;
- (void) win;

@end
