//
//  PCTutoAnimator.h
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCTutorialPicrossGame.h"
#import "cocos2d.h"

@interface PCTutoAnimator : NSObject
- (id)initWithDelegate:(PCTutorialPicrossGame*)delegate;
- (void)animateShowCells;
- (void)animateFullColumn:(CGPoint*)pnt forLenght:(uint)lenght;
-(void)stopAllActions;
@end
