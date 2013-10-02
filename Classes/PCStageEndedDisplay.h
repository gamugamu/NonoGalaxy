//
//  PCStageEndedDisplay.h
//  picrossGame
//
//  Created by loïc Abadie on 18/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface PCStageEndedDisplay : CCLayer
- (void)displayFailedWithNono:(CCTMXLayer*)nono target:(id)target callBack:(SEL)selector;
- (void)displayEndStageWithNono:(CCTMXLayer*)nono withName:(NSString*)name stageResolvedName:(NSString*)stageResolvedName stageSize:(uint)stageSize target:(id)target callBack:(SEL)selector;
@end
