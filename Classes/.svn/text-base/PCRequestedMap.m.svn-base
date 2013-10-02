//
//  PCRequestedMap.m
//  picrossGame
//
//  Created by loïc Abadie on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCRequestedMap.h"
#import "PCFilesManager.h"

@interface PCRequestedMap()
@property(nonatomic, assign)CCSprite* halo;
- (void)displayMapWithAnimation:(NSUInteger)mapIdx;
@end

@implementation PCRequestedMap
@synthesize halo;

- (id)initWithMapRequested:(NSUInteger)mapIdx{
	if(self = [super init]){
		[self displayMapWithAnimation: mapIdx];
	}
	return self;
}

- (void)displayMapWithAnimation:(NSUInteger)mapIdx{
	NSString* stagePath		= [[PCFilesManager sharedPCFileManager] getDisplayStageForIdx: mapIdx];
	CCSprite* currentMap	= [CCSprite spriteWithFile: stagePath];
	halo					= [CCSprite spriteWithFile: mapRequestHallo];
	
	CCRepeatForever* outAndIn		= [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration: .3f scale: 1.15f], [CCScaleTo actionWithDuration: .3f scale: 1] ,nil]];
	CCRepeatForever* repeatRotate	= [CCRepeatForever actionWithAction: [CCRotateBy actionWithDuration: 2 angle: 30]];
	[halo runAction: outAndIn];
	[halo runAction: repeatRotate];

	[self addChild: halo];
	[self addChild: currentMap];
}

- (void)undisplayMapWithAnimation{	
	[halo stopAllActions];
}
@end
