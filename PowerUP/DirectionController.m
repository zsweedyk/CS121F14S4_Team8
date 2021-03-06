//
//  SwitchController.m
//  PowerUP
//
//  Created by Daniel Cogan on 11/9/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "DirectionController.h"

@implementation DirectionController
{
    CGPoint start;
    CGPoint curr;
    CGPoint end;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    start = [aTouch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    curr = [aTouch locationInView:self.superview];
    
    int dx = start.x - curr.x;
    int dy = start.y - curr.y;
    
    if (abs(dx) > abs(dy)) {
        
        if (dx > 0) {
            [self.delegate performSelector:@selector(changeImage:) withObject:@"L"];
        }else{
            [self.delegate performSelector:@selector(changeImage:) withObject:@"R"];
        }
    }else{
        
        if (dy > 0) {
            [self.delegate performSelector:@selector(changeImage:) withObject:@"T"];
        }else{
            [self.delegate performSelector:@selector(changeImage:) withObject:@"B"];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    end = [aTouch locationInView:self.superview];
    
    //if user taps the component, do onTap
    if(aTouch.tapCount == 1){
        [self.delegate performSelector:@selector(onTap)];
    }
    
    [self.delegate performSelector:@selector(touchEnd)];
}

@end

