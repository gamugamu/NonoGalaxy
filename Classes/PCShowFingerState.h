//
//  PCShowFingerState.h
//  picrossGame
//
//  Created by loïc Abadie on 18/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
	fingerNone,
	fingerMoving,
	fingerSwapping,
}fingerState;

@interface PCShowFingerState : CCSpriteBatchNode
- (id)initFingerState;
- (void)cancelState;
- (void)changeFingerState:(fingerState)state;
@end
