//
//  Receiver.h
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Component.h"
#import <UIKit/UIKit.h>

@interface Receiver : Component

- (id) initWithFrame:(CGRect)frame Direction:(enum DIRECTION)dir andConnections:(NSString*)connections;

@end
