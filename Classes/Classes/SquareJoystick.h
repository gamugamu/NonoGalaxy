//
//  SquareJoystick.h
//  UsingTiled
//
//  Created by loïc Abadie on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "buttonPad.h"

@protocol squarePadDelegate
@optional
- (void)padPressed:(buttonSide)state;
- (void)padReleashed:(buttonSide)state;
@end 

@interface SquareJoystick : CCNode <CCTargetedTouchDelegate> {
	CGPoint center;
	buttonSide currentPadButton;
	id<squarePadDelegate> squarePaddelegate;
}

- (id)initWithDelegate:(id <squarePadDelegate>)delegate;
- (void)changePosition:(CGPoint)point;
@end
