//
//  PCStageJustAchieved.h
//  picrossGame
//
//  Created by loïc Abadie on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCStageData.h"


const extern uint PCStageJustAchieved_notAchieved;

@interface PCStageJustAchieved : NSObject
// Lorsqu'un stage a été accompli, renseigné le level du stage.
+ (void)setStageAccomplished:(uint)idxStageAccomplished;
// retourne le level du stage qui viens juste d'être accompli. retourn notAchieved si il n'y a pas de stage accompli.
+ (uint)lastLevelCompletedInMap:(NSString*)mapName;
@end
