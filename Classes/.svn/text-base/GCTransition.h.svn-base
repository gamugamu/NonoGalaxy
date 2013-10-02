//
//  GCTransition.h
//  picrossGame
//
//  Created by loïc Abadie on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GCTransition : CCSpriteBatchNode{
	void (^block_)();
}
- (id)initWithCallBack:(void(^)())block isReverse:(BOOL)isReverse_;
+ (id)transitionWithCallBack:(void(^)())block isReverse:(BOOL)isReverse;
@end
