//
//  PCStageEndedDisplay.m
//  picrossGame
//
//  Created by loïc Abadie on 18/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PCStageEndedDisplay.h"
#import "PCMrNono.h"
#import "PCBagroundAntiTouch.h"
#import "GameConfig.h"

@interface PCStageEndedDisplay(){
	uint		_stageSize;
	CCSprite*	_glowBuble;
}

@property (nonatomic, assign)id delegate;
@property (nonatomic, assign)SEL callback;
@property (nonatomic, retain)NSString*	stageName;

@end

@implementation PCStageEndedDisplay
@synthesize delegate,
            callback,
            stageName = _stageName;

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark --------------------------------------- public ---------------------------------------#

- (void)displayFailedWithNono:(CCTMXLayer*)nono target:(id)target callBack:(SEL)selector{
    delegate		= target;
	callback		= selector;
    
	[self animateBlackBackgroundAndOtherChunkAfterWithSelector: @selector(animateFailedSequence)];
}

- (void)displayEndStageWithNono: (CCTMXLayer*)nono withName:(NSString*)name
              stageResolvedName: (NSString*)stageResolvedName
                      stageSize: (uint)stageSize target:(id)target
                       callBack: (SEL)selector{
    delegate		= target;
	callback		= selector;
	_stageSize		= stageSize;
	self.stageName	= stageResolvedName;
	[self animateBlackBackgroundAndOtherChunkAfterWithSelector: @selector(animateAllOtherChunkSeparatly)];
}

#pragma mark override

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
    
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"stageEnded.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"levelMap.plist"];
	[super onExit];
}

- (id)init{
	if(self = [super init]){
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"levelMap.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"stageEnded.plist"];
	}
	return self;
}

- (void)dealloc{
	[_stageName release];
	[super dealloc];
}

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark -------------------------------------- private ---------------------------------------#

#pragma mark - display

- (void)animateFailedSequence{
    [self animateFailedElements];
    [self animateMrNonoFailed];
	[self addReturnToMapButton: self];
}

- (void)animateAllOtherChunkSeparatly{
	[self animateMrNonoSucceed];
	[self animateBlueGlowBuble];
	[self animateVictoryElements];
	[self displayStageBubleBackground: _stageSize];
	[self animateCompletedStage: _stageName];
	[self addReturnToMapButton: self];
}

static NSString* stgScreen[4] = {lvl_small, lvl_medium, lvl_big, lvl_big};
- (void)displayStageBubleBackground:(uint)stageSize{
	uint idx					= (uint)(stageSize / 5) - 1;
	idx = 1;
	CCSprite* backgroundBuble	= [CCSprite spriteWithSpriteFrameName: stgScreen[idx]];
	backgroundBuble.position	= ccp(IPHONEWIDTHDEMI + 17, 250);
	backgroundBuble.opacity		= 0;
	
	[self addChild: backgroundBuble];
	[backgroundBuble runAction: [CCFadeIn actionWithDuration: 1]];
}

- (void)animateBlackBackgroundAndOtherChunkAfterWithSelector:(SEL)failedOrSucceded{
	PCBagroundAntiTouch*	layer			= [PCBagroundAntiTouch layerWithColor: ccc4(26, 15, 0, 175)];
    layer.opacity	= 0;
    
	[self addChild: layer];
	[layer runAction: [CCSequence actions:
                       [CCFadeTo actionWithDuration: 2 opacity: 175],
                       [CCCallFunc actionWithTarget: self selector: failedOrSucceded], nil]];
}

- (void)animateVictoryElements{
	CCSpriteBatchNode*	layoutStageEnded		= [CCSpriteBatchNode batchNodeWithFile: @"stageEnded.png"];
	CCSprite*			victorySprite			= [CCSprite spriteWithSpriteFrameName: @"victory_14.png"];
	CCSprite*			glow					= [CCSprite spriteWithSpriteFrameName: @"victory_04.png"];
    victorySprite.position	= ccp(500, 600);
    glow.position			= ccp(485, 625);
    
	[victorySprite runAction: [CCRepeatForever actionWithAction:
                               [CCSequence actions:
								[CCScaleTo actionWithDuration: .2f scale: 1.03f],
								[CCScaleTo actionWithDuration: .2f scale: 1], nil]]];
	
	[layoutStageEnded addChild: glow];
	[layoutStageEnded addChild: victorySprite];
	
	[glow runAction: [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation: [self victoryAnimationList] restoreOriginalFrame: NO]]];
	[self addChild: layoutStageEnded];
}

- (void)animateFailedElements{
    CCSpriteBatchNode*	layoutStageEnded		= [CCSpriteBatchNode batchNodeWithFile: @"stageEnded.png"];
    CCSprite*           failedSprite            = [CCSprite spriteWithSpriteFrameName: @"failed_02.png"];
    CCSprite*			glow_1					= [CCSprite spriteWithSpriteFrameName: @"failed_07.png"];
    
    failedSprite.position	= ccp(530, 570);
    glow_1.position         = ccp(280, 270);
    glow_1.opacity          = 150;
    
    [glow_1 runAction: [CCRepeatForever actionWithAction:  [CCSequence actions:
                                                            [CCMoveTo actionWithDuration: 10 position: ccp(570, 270)],
                                                            [CCMoveTo actionWithDuration: 10 position: ccp(400, 270)],nil]]];
    
    
    [layoutStageEnded addChild: glow_1];
    [layoutStageEnded addChild: failedSprite];
    
    [self addChild: layoutStageEnded];
}

- (void)animateMrNonoSucceed{
	PCMrNono*	nono			= [[PCMrNono alloc] initWithDelegate: nil appearance: nonoVictory bubbleAppearance: messageWithVictory];
    nono.position	= ccp(180, 150);
    nono.opacity	= 0;
	
	[nono runAction: [CCSequence actions: [CCFadeTo actionWithDuration: .8f opacity: 250],
					  [CCCallBlockN actionWithBlock:
					   BCA(^{[nono talk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_mapSucceed", nil)]];}) //<------
					   ],
					  nil]];
	
	[self addChild: nono];
	[nono release];
}

- (void)animateMrNonoFailed{
	PCMrNono*	nono			= [[PCMrNono alloc] initWithDelegate: nil appearance: nonoFailed bubbleAppearance: messageWithVictory];
    nono.position	= ccp(380, 150);
    nono.opacity	= 0;
	
	[nono runAction: [CCSequence actions: [CCFadeTo actionWithDuration: .8f opacity: 250],
					  [CCCallBlockN actionWithBlock:
					   BCA(^{[nono talk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_mapFailed", nil)]];})//<------
					   ],
					  nil]];
	
	[self addChild: nono];
	[nono release];
}

- (void)animateCompletedStage:(NSString*)stageName{
	CCSprite*	completedStage			= [CCSprite spriteWithFile: stageName];
    completedStage.position = ccp(529, 250);
    completedStage.scale	= .5f;
    completedStage.opacity	= 0;
	
	[completedStage runAction:
	 [CCSequence actions:
	  [CCDelayTime actionWithDuration: .8f],
	  [CCFadeTo actionWithDuration: .3f opacity: 250],
	  [CCEaseElasticOut actionWithAction:  [CCScaleTo actionWithDuration: .9f scale: 1]],
	  nil]
	 ];
	[self addChild: completedStage];
}

- (void)animateBlueGlowBuble{
	_glowBuble				= [CCSprite spriteWithFile: @"buble.png"];
	_glowBuble.position		= ccp(530, 250);
	_glowBuble.opacity		= 0;
	_glowBuble.scale		= .5f;
    
	
	[_glowBuble runAction:
	 [CCSequence actions:
	  [CCScaleTo actionWithDuration: .5f scale: 1],
	  [CCFadeTo actionWithDuration: .4f opacity: 250],
	  [CCCallFunc actionWithTarget: self selector: @selector(pulseBubleForever)],
      nil]];
	
	[self addChild: _glowBuble];
}

- (void)pulseBubleForever{
	[_glowBuble runAction:
	 [CCRepeatForever actionWithAction:
	  [CCSequence actions:
	   [CCScaleTo actionWithDuration: .2f scale: .9f],
	   [CCScaleTo actionWithDuration: .2f scale: 1], nil]]];
}

#pragma mark - animation

- (CCAnimation*)victoryAnimationList{
	CCSpriteFrameCache*		spriteCache				= [CCSpriteFrameCache sharedSpriteFrameCache];
	NSMutableArray*			victoryGlow				= [NSMutableArray array];
    
	[victoryGlow addObject: [spriteCache spriteFrameByName: @"victory_03.png"]];
	[victoryGlow addObject: [spriteCache spriteFrameByName: @"victory_12.png"]];
    
	CCAnimation*			victoryGlowAnimation	= [CCAnimation animationWithName: @"victoryGlowAnimation" delay: .4f frames: victoryGlow];
    
	return victoryGlowAnimation;
}

#pragma mark - touchLogic

- (void)addReturnToMapButton:(CCNode*)parent{
	CCMenuItemSprite* btnS	= [CCMenuItemSprite itemFromNormalSprite: [CCSprite spriteWithFile: @"mapBtn.png"]
													 selectedSprite: nil
															 target: self
														   selector: @selector(onReturnToMap)];
	CCMenu* btn		= [CCMenu menuWithItems: btnS, nil];
	btn.position	= ccp(1000, 180);
	[parent addChild: btn];
}

- (void)onReturnToMap{
	[delegate performSelector: callback];
}

@end
