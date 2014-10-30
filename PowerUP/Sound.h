//
//  Sound.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/29/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

@interface Sound : NSObject
{
    SystemSoundID soundID;
}

- (id)initWithSoundNamed:(NSString *)filename;
- (void)play;

@end
