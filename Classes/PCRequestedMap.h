//
//  PCRequestedMap.h
//  picrossGame
//
//  Created by loïc Abadie on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface PCRequestedMap : CCNode
- (id)initWithMapRequested:(NSUInteger)mapIdx;
- (void)undisplayMapWithAnimation;
@end
