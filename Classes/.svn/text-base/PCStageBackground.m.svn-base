//
//  PCStageBackground.m
//  picrossGame
//
//  Created by loïc Abadie on 19/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCStageBackground.h"
#import "UIColor+HexColor.h"

@implementation PCStageBackground

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark --------------------------------------- public ---------------------------------------#

- (id)initWithHexBackgroundColor:(NSString*)backgroundColor andSubHexBagroundColor:(NSString*)subBackgroundColor{
    if (self = [super initWithColor: [PCStageBackground convertColorStringToColorGlib: backgroundColor]]) {
        [self setUpBackground: subBackgroundColor];
    }
    return self;
}

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark -------------------------------------- private ---------------------------------------#

+ (ccColor4B)convertColorStringToColorGlib:(NSString*)stringColor{
	float red, blue, green, alpha;

	if(stringColor){
		UIColor* color = [UIColor colorWithHexString: stringColor];
		[color getRed: &red green: &blue blue: &green alpha: &alpha];
		
		red		*= 250;
		blue	*= 250;
		green	*= 250;
		alpha	*= 250;
	}
	else {
		red		= 100;
		blue	= 100;
		green	= 100;
		alpha	= 100;
	}

	return ccc4(red, blue, green, alpha);
}

- (void)setUpBackground:(NSString*)subColor{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"backgroundStage.plist"];
	CCSpriteBatchNode* batch	= [CCSpriteBatchNode batchNodeWithFile: @"backgroundStage.png"];

	// nebuleuse
	CCSprite* nebul_0	= [CCSprite spriteWithSpriteFrameName: @"galax_01.png"];
	nebul_0.scale		= 1.5f;
	nebul_0.position	= ccp(320, 415);
	nebul_0.color		= ccc3(0, 255, 255);
	[batch addChild: nebul_0];
	
	CCSprite* nebul_1	= [CCSprite spriteWithSpriteFrameName: @"galax_02.png"];
	nebul_1.scale		= 1.5f;
	nebul_1.position	= ccp(800, 350);
	[batch addChild: nebul_1];
	
	CCSprite* nebul_2	= [CCSprite spriteWithSpriteFrameName: @"galax_02.png"];
	nebul_2.scale		= 1.5f;
	nebul_2.rotation	= 150;
	nebul_2.position	= ccp(250, 50);
	[batch addChild: nebul_2];
	
	const int totalStarsLimit = 5;
	static NSString* const starsName[totalStarsLimit] = {@"stars_07.png", @"stars_10.png", @"stars_14.png", @"stars_15.png", @"stars_16.png"};
	
	for (int i = 0;  i < 50; i++) {
		CCSprite* star	= [CCSprite spriteWithSpriteFrameName: starsName[rand() % totalStarsLimit]];
		star.scale		= (rand() % 15) / 10.f;
		star.rotation	= rand() % 180;
		star.position	= ccp(rand() % 1024, rand() % 768);
		[batch addChild: star];
	}
	
	for (int i = 0;  i < 15; i++) {
		CCSprite* star	= [CCSprite spriteWithSpriteFrameName: @"stars_06.png"];
		star.scale		= (rand() % 10) / 10.f;
		star.position	= ccp(rand() % 1024, rand() % 768);
		[batch addChild: star];
	}

	ccColor4B color			= subColor? [PCStageBackground convertColorStringToColorGlib: subColor] : ccc4(0, 50, 0, 250);
	CCColorLayer* surColor	= [[CCColorLayer alloc] initWithColor: color width: self.contentSize.width height: self.contentSize.height];
	
	[self addChild: surColor];
	[self addChild: batch];
}

@end
