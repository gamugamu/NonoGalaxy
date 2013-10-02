//
//  PCBagroundAntiTouch.h
//  picrossGame
//
//  Created by loïc Abadie on 26/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"

@interface PCBagroundAntiTouch : CCColorLayer
@property(nonatomic, readonly)int priority;
- (void)cancelDSwallow;
@end
