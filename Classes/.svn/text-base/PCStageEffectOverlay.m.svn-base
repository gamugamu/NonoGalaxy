//
//  PCStageEffectOverlay.m
//  picrossGame
//
//  Created by loïc Abadie on 10/10/12.
//
//

#import "PCStageEffectOverlay.h"
#import "CCLayer.h"

@interface PCStageEffectOverlay(){
	CCColorLayer* _redImpactError;
}
@end

@implementation PCStageEffectOverlay

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark --------------------------------------- public ---------------------------------------#

- (void)effectYouMadeError:(float)duration{
	[_redImpactError runAction: [CCSequence actionOne: [CCFadeIn actionWithDuration: .2f]
												  two: [CCFadeOut actionWithDuration: .2f]]];
}

#pragma mark - alloc / dealloc

- (id)init{
	if(self = [super init]){
		[self setUpRedImpactError];
	}
	return self;
}

- (void)dealloc{
	[_redImpactError release];
	[super dealloc];
}

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark -------------------------------------- private ---------------------------------------#

#pragma mark - setUp

- (void)setUpRedImpactError{
	_redImpactError			= [[CCColorLayer layerWithColor: ccc4(250, 0, 0, 50)] retain];
	_redImpactError.opacity = 0;
	[self addChild: _redImpactError];
}

#pragma mark - display

- (void)displayImpactError{
	
}

@end
