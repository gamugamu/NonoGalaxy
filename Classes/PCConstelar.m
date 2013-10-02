//
//  PCConstelar.m
//  picrossGame
//
//  Created by loïc Abadie on 03/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCConstelar.h"
#import "GameConfig.h"
#import "GGBasicStruct.h"
#import "CCLabelBMFontMultiline.h"

@interface PCBkgMedals : CCSprite
- (void)changeAppearance:(float)size_ color:(ccColor4B)color;
@end

@interface PCConstelarInfo : CCNode
- (void)displayStageInfo:(stageData)data;
@end

@interface PCConstelar()
@property(nonatomic, retain)CCSpriteBatchNode*			screensStagesBatch;
@property(nonatomic, retain)CCNode*						background;
@property(nonatomic, retain)CCSprite*					_screenDisplay;
@property(nonatomic, retain)PCBkgMedals*				_bkgMedal;
@property(nonatomic, retain)PCConstelarInfo*			_stageInfoDisplay;

- (void)displayScreen:(stageData)stageData;
- (void)displayStageComplete:(CCTMXLayer*)layerMap withStageData:(stageData)sData;
- (void)displayStageInfo:(stageData)stageData;
- (void)displayEligible;
- (void)setUpStageComplete:(stageData*)stageData;
@end
		
@implementation PCConstelar
@synthesize screensStagesBatch,
			background,
			_stageInfoDisplay,
			_screenDisplay,
			_item,
			_bkgMedal;

static NSString* stgScreen[8] = {lvl_no_small, lvl_no_small, lvl_no_small, lvl_no_small, lvl_small, lvl_medium, lvl_big, lvl_big};

#pragma mark public
static int currentLevelHighlighted = -1;

+ (void)resetStatic{
	currentLevelHighlighted = -1;
}

- (void)setHilighted:(BOOL)isHilighted{
	/*
	NSString* frameName = nil;
	
	if(isHilighted){
		frameName				= @"picross_05.png";
		_screenDisplay.opacity	= 255;
		//[_screenDisplay runAction: [CCFadeTo actionWithDuration: 1 opacity: 250]];
	}else{
		frameName = stgAnchor;
		_screenDisplay.opacity	= 150;
		//[_screenDisplay runAction: [CCFadeTo actionWithDuration: 1 opacity: 100]];
	}
*/
	//[self setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName]];//<---
}

- (void)constelarTouched{
	id a1		= [CCScaleTo actionWithDuration: 0.5f scale: 0.8f];
	id a2		= [CCScaleTo actionWithDuration: 0.5f scale: 1];
	[_screenDisplay runAction: [CCEaseElasticOut actionWithAction: [CCSequence actions: a1, a2, nil] period: .2f]];
}

- (void)setHilighted:(BOOL)isHilighted forLevel:(uint)level{
	[self setHilighted: isHilighted];
	currentLevelHighlighted = level;
}

- (void)makeEligible:(stageData*)stageData_{
	stageData_->isEligible = YES;
	[self displayEligible];
}

- (void)undoEligible:(stageData*)stageData_{
	stageData_->isEligible = NO;
	[self unDisplayEligible];
}

- (void)pulseConstelar{
	id a1		= [CCScaleTo actionWithDuration: 0.5f scale: 0.8f];
	id a2		= [CCScaleTo actionWithDuration: 0.1f scale: 1];
	id action2	= [CCRepeatForever actionWithAction: [CCSequence actions: a1, a2, nil]];
	
	[_screenDisplay runAction: action2];
}

#define STAGEMAPTAG		100

- (CCSprite*)aggregate{
    return (CCSprite*)[self getChildByTag: STAGEMAPTAG];
}

- (void)displayAgregate{
	CCSprite* displaySprite = (CCSprite*)[self getChildByTag: STAGEMAPTAG];	
	displaySprite.visible	= YES;
}

- (void)undisplayAgregate{
	CCSprite* displaySprite = (CCSprite*)[self getChildByTag: STAGEMAPTAG];	
	displaySprite.visible	= NO;
}

#pragma mark - animate

#pragma mark override

- (GLubyte)opacity{
	return opacity_;
}

- (void)setOpacity: (GLubyte) opacity{
	opacity_ = opacity;
	for( CCNode *a in [self children] )
		[(id <CCRGBAProtocol>) a setOpacity: opacity];
}

#define LAYERSTAGETAG	0
- (void)drawStage:(CCTMXLayer*)stageMap stageData:(stageData)stageData menu:(CCMenu*)menu{
	if(stageData.isDone){
		//if(![self getChildByTag: STAGEMAPTAG])
        [self setUpStageComplete: &stageData];
        
		[self displayStageComplete: stageMap withStageData: stageData];
	}
	else
		[self getChildByTag: STAGEMAPTAG].visible = NO;

	_item.position  = stageData.pxBox.origin;
    _item.tag		= stageData.level;
    self.visible	= YES;

	[self setHilighted: (stageData.level == currentLevelHighlighted)];
    [self displayScreen: stageData];
	[self displayStageInfo: stageData];
}

- (void)unDrawStage:(CCMenu*)menu{
	self.visible			= NO;
	_bkgMedal.visible		= NO;
	_screenDisplay.visible	= NO;
	[_screenDisplay stopAllActions];
}

#pragma mark private
#pragma mark setup
- (void)displayScreen:(stageData)stageData{
	uint size			= stageData.mapSize;
	uint currentscreen	= (stageData.isDone)?  size / SIZEGRIDCUT + SIZEGRIDCUT - 1 : size / SIZEGRIDCUT;
	
	CGPoint sdposition	= ccp(-50, -50);
	
	if(!_screenDisplay){
		[self set_screenDisplay: [CCSprite spriteWithSpriteFrameName: stgScreen[currentscreen - 1]]];
		[screensStagesBatch addChild: _screenDisplay];		
	}
	else{
		if(stageData.isEligible)
			[self displayEligible];
		else{
			[_screenDisplay setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: stgScreen[currentscreen - 1]]];
        }
	}

	_screenDisplay.position = ccpAdd(sdposition, stageData.pxBox.origin);
	_screenDisplay.visible	= YES;
}

- (void)displayStageInfo:(stageData)stageData{
	/*
	float medalSize = 0;
	
	switch (stageData.mapSize) {
		case 5:		medalSize = 39; break;
		case 10:	medalSize = 45.5f; break;
		case 15:	medalSize = 50; break;
		case 20:	medalSize = 56; break;
	}
	
	[_bkgMedal changeAppearance: medalSize color:(ccColor4B){0,0,0,0}];
	[_stageInfoDisplay displayStageInfo: stageData];*/
}

- (void)displayEligible{
	[_screenDisplay setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: lvl_no_big]];
	[self pulseConstelar];
}

- (void)unDisplayEligible{
	[_screenDisplay setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: lvl_no_small]];
	[_screenDisplay stopAllActions];
}

- (void)displayStageComplete:(CCTMXLayer*)layerMap withStageData:(stageData)sData{
	CCSprite* displaySprite = (CCSprite*)[self getChildByTag: STAGEMAPTAG];	
	displaySprite.position	= ccp(50, 50);
	displaySprite.visible	= YES;
}

#pragma mark setUp
- (void)setUpStageComplete:(stageData*)stageData{
	CCSprite* spriteStageCompleted	= [CCSprite spriteWithFile: stageData->urlDisplayStageDone];

    if([self getChildByTag: STAGEMAPTAG])
        [self removeChildByTag: STAGEMAPTAG cleanup: NO];
    
	[self addChild: spriteStageCompleted z: 0 tag: STAGEMAPTAG];
	spriteStageCompleted.visible	= NO;
}

#pragma mark alloc / dealloc
+ (id)constelar:(CCSpriteBatchNode*)screensStagesBatch withBackground:(CCNode*)background{
	return [[[PCConstelar alloc] initWithBatch: screensStagesBatch withBackground: background] autorelease];
}

- (id)initWithBatch:(CCSpriteBatchNode*)screensStagesBatch_ withBackground:(CCNode*)background_{
	//if ((self = [super initWithSpriteFrameName: stgAnchor])) {
	if ((self = [super initWithFile:@"alpha0_btn.png" rect: CGRectMake(0, 0, 100, 100)])) {
		self.visible				= NO;
		self.background					= background_;
		self.screensStagesBatch			= screensStagesBatch_;
	}
	return self;
}

- (void)dealloc{
	[_stageInfoDisplay	release];
	[_bkgMedal			release];
	[_screenDisplay stopAllActions];
	[_screenDisplay		release];
	[super				dealloc];
}
@end

@interface PCBkgMedals()
@property(nonatomic, assign)float		size;
@property(nonatomic, assign)ccColor3B	color;
@end

@implementation PCBkgMedals
@synthesize color,
			size;

#pragma mark public
- (void)changeAppearance:(float)size_ color:(ccColor4B)degree{
	size	= size_;
	
	switch (rand()%4) {//<--- should be defined by stageDate, not random
		case 0: color = ccc3(100, 205, 225);	break;		// blue
		case 1: color = ccc3(140, 200, 60);		break;		// green
		case 2: color = ccc3(240, 100, 35);		break;		// orange
		case 3: color = ccc3(240, 40, 40);		break;		// red
	}
}

#pragma mark private
- (void)draw{
	glLineWidth(0);
	glColor4ub(color.r, color.g, color.b, 255);
	ccFillCircle(CGPointZero, size, 0, 11, NO);
	
	[super draw];
}

#pragma mark alloc/dealloc
- (id)init{
	if(self = [super init]){
		color = ccBLACK;
	}
	return self;
}
@end

//*************************************************************************************************//
@interface PCConstelarInfo()
@property(nonatomic, retain)CCLabelBMFont*	_labelTime;
@property(nonatomic, retain)CCLabelBMFont*	_labelStageName;
@property(nonatomic, retain)CCLabelBMFont*	_labelLevel;
@end

@implementation PCConstelarInfo
@synthesize _labelTime,
			_labelStageName,
			_labelLevel;

- (void)displayStageInfo:(stageData)data{
	//data.mapSize;
	switch (data.mapSize) {
		case 5:		_labelTime.position			= ccp(49, 71);
					_labelStageName.position	= ccp(50, 60); 
					_labelLevel.position		= ccp(7.5f, 78); break;
		case 10:	_labelTime.position			= ccp(49, 75);
					_labelStageName.position	= ccp(50, 63);
					_labelLevel.position		= ccp(4, 81); break;
		case 15:	_labelTime.position			= ccp(49, 79);
					_labelStageName.position	= ccp(50, 67);
					_labelLevel.position		= ccp(2, 88); break;
		case 20:	_labelTime.position			= ccp(49, 85);
					_labelStageName.position	= ccp(50, 73);
					_labelLevel.position		= ccp(0, 92); break;
	}
	
	_labelTime.visible		= data.isDone;
	_labelStageName.visible = data.isDone;
	[_labelLevel setString: [NSString stringWithFormat: @"%u", data.level]];
}

- (id)init{
	if(self = [super init]){
		[self set_labelTime: [CCLabelBMFont labelWithString:@"00:12:12" fntFile:@"FntHooge_12.fnt"]];
		[[_labelTime textureAtlas].texture setAliasTexParameters];
		
		[self set_labelStageName: [CCLabelBMFont labelWithString:@"nabuchodonosaurus" fntFile:@"Fnt04_10.fnt"]];		
		[[_labelStageName textureAtlas].texture setAliasTexParameters];
		
		[self set_labelLevel: [CCLabelBMFont labelWithString:@"0" fntFile:@"FntProvidence_14.fnt"]];
		[self addChild: _labelTime];
		[self addChild: _labelStageName];
		[self addChild: _labelLevel];
	}
	return self;
}

- (void)dealloc{
	[_labelLevel		release];
	[_labelStageName	release];
	[_labelTime			release];
	[super				dealloc];
}
@end