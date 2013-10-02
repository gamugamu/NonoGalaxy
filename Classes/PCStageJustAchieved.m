//
//  PCStageJustAchieved.m
//  picrossGame
//
//  Created by loïc Abadie on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCStageJustAchieved.h"

@implementation PCStageJustAchieved

const uint PCStageJustAchieved_notAchieved		= 800;

static uint currentStageSlected                 = PCStageJustAchieved_notAchieved;

+ (void)setStageAccomplished:(uint)idxStageAccomplished{
	currentStageSlected = idxStageAccomplished;
}

+ (uint)lastLevelCompletedInMap:(NSString*)mapName{
	return currentStageSlected;
}
@end
