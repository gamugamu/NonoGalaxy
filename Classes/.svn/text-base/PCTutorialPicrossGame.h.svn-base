//
//  PCTutorialPicrossGame.h
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCPicrossGame.h"

typedef enum{
	simulateSimpleMove,
	simulateCrossMove,
	simulateFillMove
}simulateFinger;

typedef enum{
	tuto_1_basis,
	tuto_2_showMove,
	tuto_3_10x10,
	tuto_4_15x15ShowMove
}tutoLesson;

@interface PCTutorialPicrossGame : PCPicrossGame
- (id)initWithEngine:(id <PEngine>)engine andDelegate:(id <PCPicrossGameDelegate>)delegate_ forTutoLesson:(tutoLesson)tutoLesson;
- (void)simulateFingerTouch:(CGPoint)pnt forFingerState:(simulateFinger)state size:(uint)size;
- (void)simulateInMovingTouch:(CGPoint)pnt isOrigin:(BOOL)isOrigin;
- (void)tutoIsAnimating:(BOOL)isAnimating;
- (void)animationDone;
@property(nonatomic, assign)BOOL isBlocking;
@end
