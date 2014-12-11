//
//  Switch.m
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Switch.h"

@implementation Switch {

    int row;
    int col;
    UIImageView* tempImage;
    NSString *tempConnections;
}

#pragma mark - Intialization

- (id) initWithFrame:(CGRect)frame AtRow:(int)initRow AndCol:(int)initCol WithConnections:(NSString*)connections {
    
    self = [super initWithFrame:frame];

    [self setUpImageNameWithConnection:connections];
    
    row = initRow;
    col = initCol;
    tempConnections = [self getConnections];
    self.touchEnteredDir = NONE;
    self.touchExitedDir = NONE;
    
    [self displayImage];
    
    return self;
}

#pragma mark - Public Methods

- (void) addEnteredDirection {
    
    NSString *connections = [self getConnections];
    
    connections = [self addDirection:self.touchEnteredDir toOrientation:connections];
    [self setUpImageNameWithConnection:connections];
    [self switchChanged];
    [self resetTemp];
}

- (void) addExitedDirection {
    
    NSString *connections = [self getConnections];
    
    connections = [self addDirection:self.touchExitedDir toOrientation:connections];
    [self setUpImageNameWithConnection:connections];
    [self switchChanged];
    [self resetTemp];
}

- (void) tempAddEnteredDirection {
    
    tempConnections = [self addDirection:self.touchEnteredDir toOrientation:tempConnections];
    [self displayTempImage];
}

- (void) tempAddExitedDirection {
    
    tempConnections = [self addDirection:self.touchExitedDir toOrientation:tempConnections];
    [self displayTempImage];
}

- (void) tempRemoveEnteredDirection {
    
    tempConnections = [self removeDirection:self.touchEnteredDir fromConnections:tempConnections];
    [self displayTempImage];
}

- (void) tempRemoveExitedDirection {
    
    tempConnections = [self removeDirection:self.touchExitedDir fromConnections:tempConnections];
    [self displayTempImage];
}

- (void) resetDirection
{
    [self setUpImageNameWithConnection:@"XXXX"];

    [self switchChanged];
}

- (int) getPosition {
    return 100*row + col;
}

#pragma mark - Private Methods

- (void) setUpImageNameWithConnection:(NSString*)connections {
    self.imageName = [NSString stringWithFormat:@"switch%@on",connections];
}

- (void) switchChanged {
    
    NSString* connections = [self getConnections];
    
    NSNumber *position = [NSNumber numberWithInt:[self getPosition]];
    [self.delegate performSelector:@selector(switchChangedAtPosition:WithConnections:) withObject:position withObject:connections];
}

- (NSString*) addDirection:(enum DIRECTION)dir toOrientation:(NSString*)orient {
    
    NSString* start;
    NSString* mid;
    NSString* end;
    
    switch (dir) {
        case LEFT:
            start = @"";
            mid = @"L";
            end = [orient substringFromIndex:1];
            break;
        case RIGHT:
            start = [orient substringToIndex:1];
            mid = @"R";
            end = [orient substringFromIndex:2];
            break;
        case TOP:
            start = [orient substringToIndex:2];
            mid = @"T";
            end = [orient substringFromIndex:3];
            break;
        case BOTTOM:
            start = [orient substringToIndex:3];
            mid = @"B";
            end = @"";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@%@", start, mid, end];
}

- (NSString*) removeDirection:(enum DIRECTION) dir fromConnections:(NSString*)connections {
    NSString *replace = @"";
    switch (dir) {
        case LEFT:
            replace = @"L";
            break;
        case RIGHT:
            replace = @"R";
            break;
        case TOP:
            replace = @"T";
            break;
        case BOTTOM:
            replace = @"B";
            break;
        default:
            break;
    }
    
    return [connections stringByReplacingOccurrencesOfString:replace withString:@"X"];
}

- (void) displayTempImage {
    [self.image removeFromSuperview];
    [tempImage removeFromSuperview];
    
    NSString *connections = [self getCombinedConnections];
    
    NSString* tempImageName = [NSString stringWithFormat:@"switch%@on",connections];
    CGRect viewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    tempImage = [[UIImageView alloc] initWithFrame:viewFrame];
    tempImage.image = [UIImage imageNamed:tempImageName];

    [self addSubview:tempImage];
}

- (NSString*) getCombinedConnections {
    NSString *currConnections = [self getConnections];
    NSString *combinedConnections = @"";
    
    NSString *dir = [currConnections substringToIndex:1];
    if ([dir isEqualToString:@"X"]) {
        dir = [tempConnections substringToIndex:1];
    }
    combinedConnections = [combinedConnections stringByAppendingString:dir];
    
    dir = [currConnections substringWithRange:NSMakeRange(1, 1)];
    if ([dir isEqualToString:@"X"]) {
        dir = [tempConnections substringWithRange:NSMakeRange(1, 1)];
    }
    combinedConnections = [combinedConnections stringByAppendingString:dir];
    
    dir = [currConnections substringWithRange:NSMakeRange(2, 1)];
    if ([dir isEqualToString:@"X"]) {
        dir = [tempConnections substringWithRange:NSMakeRange(2, 1)];
    }
    combinedConnections = [combinedConnections stringByAppendingString:dir];
    
    dir = [currConnections substringFromIndex:3];
    if ([dir isEqualToString:@"X"]) {
        dir = [tempConnections substringFromIndex:3];
    }
    combinedConnections = [combinedConnections stringByAppendingString:dir];

    return combinedConnections;
}

- (void) resetTemp {
    [tempImage removeFromSuperview];
    tempConnections = @"XXXXon";
}

@end