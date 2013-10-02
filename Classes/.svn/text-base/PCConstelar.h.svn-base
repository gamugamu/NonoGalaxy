//
//  PCConstelar.h
//  picrossGame
//
//  Created by loïc Abadie on 03/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PCStageData.h"

@interface PCConstelar : CCSprite
+ (id)constelar:(CCSpriteBatchNode*)screensStagesBatch withBackground:(CCNode*)background;
+ (void)resetStatic;
- (id)initWithBatch:(CCSpriteBatchNode*)screensStagesBatch_ withBackground:(CCNode*)background_;
- (void)setHilighted:(BOOL)isHilghted;
- (void)setHilighted:(BOOL)isHilighted forLevel:(uint)level;
- (void)drawStage:(CCTMXLayer*)stageMap stageData:(stageData)stageData menu:(CCMenu*)menu;
// affiche le stage qui sont accessible.
- (void)makeEligible:(stageData*)stageData_;
// annule [makeEligible].
- (void)undoEligible:(stageData*)stageData_;
- (void)constelarTouched;
- (void)unDrawStage:(CCMenu*)menu;
- (CCSprite*)aggregate;
// affiche tout les éléments du stage tel que l'image du stage lorsqu'il a été résolu.
- (void)displayAgregate;
// cache les éléments du stage, relatif à [displayAgreate].
- (void)undisplayAgregate;
@property(nonatomic, assign)CCMenuItemSprite*	_item;
@property(nonatomic, retain, readonly)CCSprite*			_screenDisplay;
@end
