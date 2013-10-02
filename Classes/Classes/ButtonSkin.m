//
//  ButtonSkin.m
//  UsingTiled
//
//  Created by loïc Abadie on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonSkin.h"

@implementation ButtonSkin
@synthesize isHilighted = _isHilighted;

#define DEFAULTSKIN_TAG 0
#define HIGHLIGHTSKIN 1

- (id)initWithSkin:(NSString*)defaultSkin andHighlightSkin:(NSString*)highLightSkin{
	
	if(self = [super init]){
		[self addChild:[CCSprite spriteWithFile:defaultSkin]	z: 0 tag: DEFAULTSKIN_TAG];
		[self addChild:[CCSprite spriteWithFile:highLightSkin]	z: 0 tag: HIGHLIGHTSKIN];
		[self setHightLight:NO];
	}
	return self;
}

- (void)setHightLight:(BOOL)isHilghligted{
	((CCSprite*)[self getChildByTag: DEFAULTSKIN_TAG]).visible	= isHilghligted;
	((CCSprite*)[self getChildByTag: HIGHLIGHTSKIN]).visible = !isHilghligted;
    _isHilighted = isHilghligted;
}

- (CGSize)buttonSize{
	return 	[(CCSprite*)[self getChildByTag: DEFAULTSKIN_TAG] textureRect].size;
}

- (BOOL)isHilghligted{
	return [(CCSprite*)[self getChildByTag:HIGHLIGHTSKIN] opacity]? YES:NO;
}
@end

#undef DEFAULTSKIN_TAG
#undef HIGHLIGHTSKIN