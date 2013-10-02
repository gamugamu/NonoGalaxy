//
//  PCTimer.h
//  picrossGame
//
//  Created by loïc Abadie on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLabelBMFontMultiline.h"

@interface PCTimer : CCLabelBMFontMultiline
- (void)reset;
- (void)start;
- (void)stop;
- (void)addTime:(uint)second;
@property(nonatomic, readonly)ccTime currentTime;
@end
