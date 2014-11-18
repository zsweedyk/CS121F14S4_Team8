//
//  SwitchController.m
//  PowerUP
//
//  Created by Daniel Cogan on 11/9/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "DirectionController.h"

@implementation DirectionController

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
CGPoint start;
CGPoint curr;
CGPoint end;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    start = [aTouch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    curr = [aTouch locationInView:self.superview];
    
    int dx = start.x-curr.x;
    int dy = start.y-curr.y;
    
    if (abs(dx)>abs(dy)) {
        if (dx>0) {
            [self.delegate performSelector:@selector(changeImage:) withObject:@"L"];
        }else{
            [self.delegate performSelector:@selector(changeImage:) withObject:@"R"];
        }
    }else{
        if (dy>0) {
            [self.delegate performSelector:@selector(changeImage:) withObject:@"T"];
        }else{
            [self.delegate performSelector:@selector(changeImage:) withObject:@"B"];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    end = [aTouch locationInView:self.superview];
    int dx = start.x-end.x;
    int dy = start.y-end.y;
    //if user taps the component, do onTap
    if(aTouch.tapCount == 1){
        [self.delegate performSelector:@selector(onTap)];
    }else{
        if (abs(dx)>abs(dy)) {
            if (dx>0) {
                [self.delegate performSelector:@selector(rotateDeflector:) withObject:@"L"];
            }else{
                [self.delegate performSelector:@selector(rotateDeflector:) withObject:@"R"];
            }
        }else{
            if (dy>0) {
                [self.delegate performSelector:@selector(rotateDeflector:) withObject:@"T"];
            }else{
                [self.delegate performSelector:@selector(rotateDeflector:) withObject:@"B"];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end

