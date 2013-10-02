//
//  PCTutoStageBoard.h
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCStageBoard.h"

@protocol tutoStageBoardDelegate<PCStageBoardDelegate>
- (void)touchesDone:(CCArray*)touch;
- (BOOL)allowingTouch;
- (BOOL)allowCancel;
- (void)cancelHasBeenDone;
@property(nonatomic, readonly)NSMutableSet*	_allowedActions;
@end

@interface PCTutoStageBoard : PCStageBoard
- (void)simulate_ccTouchesEnded;
- (void)simulateHint:(NSSet*)hintList;
- (void)clearHint;
@property (nonatomic, assign)BOOL needAllAction;
@end
