//
//  PCMicroResumeMapBackground.h
//  picrossGame
//
//  Created by loïc Abadie on 07/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PCConstelationMap.h"

@interface PCMicroResumeMapBackground : CCSprite
- (id)initMicroResume:(CCSpriteBatchNode*)stars;
- (void)displayItinerary:(CCNode*)itinerary contentSize:(CGRect)content;
- (void)mapAvailability:(CCArray*)reasons;
- (void)newMapInfo:(uint)difficulty stageCompleted:(lvlDone_lvlTotal*)completed forstageName:(NSString*)stageName;
@property(nonatomic, retain)CCSpriteBatchNode* _starsLayer;
@end
