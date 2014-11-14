//
//  ExplosionScene.m
//  PowerUP
//
//  Created by Cyrus Huang on 11/13/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "ExplosionScene.h"
#import <SpriteKit/SpriteKit.h>

@implementation ExplosionScene

- (void)didMoveToView: (SKView *) view
{
    [self createSceneContents];
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;

    NSString* explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    
    SKEmitterNode* explosionNode = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    
    explosionNode.position = CGPointMake(100,100);
    
    [self addChild:explosionNode];
}

@end
