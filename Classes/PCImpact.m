//
//  PCImpact.m
//  picrossGame
//
//  Created by loïc Abadie on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCImpact.h"
#import "GameConfig.h"

@interface PCImpact(){
}
@end

@implementation PCImpact

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark --------------------------------------- public ---------------------------------------#

- (void)calibrate:(CGPoint)pnt{
	//self.position = pnt;
}

- (void)makeImpactAtPosition:(CGPoint)pnt forState:(picrossState)state{
	ccColor3B tint;
	
	switch (state) {
		case PICCROSSED:	tint =  ccc3(250, 250, 250);	break;
		case PICUNCROSSED:	tint =  ccc3(250, 250, 250);	break;
		case PICFILLED:		tint =  ccc3(250, 250, 250);	break;
		case PICERROR:		tint =  ccc3(250, 250, 250);	break;
		default:			tint =  ccc3(250, 250, 250);	break;
	}
				pnt				= invertCoordinateHelper(pnt);
	CCSprite*	impact			= [CCSprite spriteWithFile: @"blow.png"];
				impact.position	= (CGPoint){pnt.x * TILESIZE + 22, pnt.y * TILESIZE + 22};
	
	impact.anchorPoint			= ccp(0.5,0.5);
	impact.color				= tint;
	
	[self addChild: impact];
	[impact runAction: [CCSequence actions:
						[CCSpawn actionOne: [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .3f scale: 1.4f]] two: [CCFadeOut actionWithDuration: .3f]],
						[CCCallBlockN actionWithBlock: BCA(^(CCNode *n){ [self removeChild: impact cleanup: YES];})], nil]];
}

#pragma mark - alloc / dealloc

- (id)init{
	if(self = [super init]){
	}
	return self;
}

- (void)dealloc{
	[super dealloc];
}

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark -------------------------------------- private ---------------------------------------#

@end
