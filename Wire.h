//
//  Wire.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Component.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Wire : Component

-(id) initWithFrame:(CGRect)frame andConnections:(NSString*)connections;

@end
