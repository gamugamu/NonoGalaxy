//
//  PCGalaxyReminder.m
//  picrossGame
//
//  Created by loïc Abadie on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCGalaxyReminder.h"

@implementation PCGalaxyReminder

#pragma mark public
#define TAG_COMPLETED 1
- (void)updatecompleted:(uint)completed forTotal:(uint)total{
	CCLabelBMFont* completedNum = (CCLabelBMFont*)[self getChildByTag: TAG_COMPLETED];
	[completedNum setString: [NSString stringWithFormat: @"%u/%u", completed, total]];
}

#pragma mark setup
- (void)setUpDisplay:(NSString*)displayName andGalaxyName:(NSString*)galaxyName{
	//CCSprite* glow						= [CCSprite spriteWithFile: @"stage_glow.png"]; //<---
	CCSprite* completed					= [CCSprite spriteWithFile: @"compt.png"];
	CCLabelBMFont* stageName			= [CCLabelBMFont labelWithString: galaxyName fntFile: @"FntFutura_35.fnt"]; //<---
	CCLabelBMFont* completedNum			= [CCLabelBMFont labelWithString: @"" fntFile: @"FntFutura_48.fnt"];
	//CCSprite* galaxydisplay				= [CCSprite spriteWithFile: displayName];
	//CCNode* classicDisplay			= [CCSprite spriteWithFile: @"clsBn.png"]; //<---
	// CCNode* infoStageDisplay			= [CCSprite spriteWithFile: @"infoLvl.png"]; //<---
	
	//glow.position						= ccp(86, 87);
	stageName.position					= ccp(stageName.contentSize.width/2 + 210, 43);
	//galaxydisplay.scale					= .65f;
	//galaxydisplay.position				= ccp(86.5f, 85);
	//classicDisplay.position				= ccp(252, 20);
	//infoStageDisplay.position			= ccp(150, 690);
	completed.position					= ccp(870, 690);
	completedNum.position				= ccp(868, 650);
	
	//[self addChild: glow];
	[self addChild: completed];
	//[self addChild: stageName];
	//[self addChild: galaxydisplay];
	//[self addChild: classicDisplay];
	// [self addChild: infoStageDisplay];
	[self addChild: completedNum z: 0 tag: TAG_COMPLETED];
}

- (id)initWithDisplay:(NSString*)displayName andGalaxyName:(NSString*)galaxyName{
    if (self = [super init]) {
		[self setUpDisplay: displayName andGalaxyName: @"PICROSS ACADEMY"]; //<----
    }
    
    return self;
}

- (void)dealloc{
    [super dealloc];
}

@end
