//
//  Wire.h
//  PowerUP
//
//  Created by Cyrus Huang on 10/26/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Wire : UIImageView

@property (nonatomic) NSInteger tag;

-(id) initWithFrame:(CGRect)frame andOrientation:(NSString*)imageName;

@end
