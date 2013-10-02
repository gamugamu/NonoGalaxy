//
//  PCMicroResumeMapBackground.m
//  picrossGame
//
//  Created by loïc Abadie on 07/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCMicroResumeMapBackground.h"
#import "PCPicrossDataBase.h"
#import "PCStageData.h"
#import "GameConfig.h"
#import "CCLabelBMFontMultiline.h"

@interface PCMicroResumeMapBackground()
@property(nonatomic, retain)CCSprite*		_cantAccess;
@property(nonatomic, retain)CCNode*			_itinerary;
@property(nonatomic, retain)CCLabelBMFontMultiline*	_stageInfo;
@property(nonatomic, retain)CCLabelBMFontMultiline*	_mapTitle;
@end

@implementation PCMicroResumeMapBackground
@synthesize _starsLayer,
			_stageInfo,
			_itinerary,
			_mapTitle,
			_cantAccess;

#pragma mark public
- (void)mapAvailability:(CCArray*)reasons{
	BOOL hasreason = [reasons count];
	_cantAccess.visible = hasreason;
	
	CCSprite* sprite;
	
	CCARRAY_FOREACH([_starsLayer children], sprite)
		sprite.opacity = (hasreason)? 150 : 255;
}

- (void)displayItinerary:(CCNode*)itinerary contentSize:(CGRect)content{
	[self removeChild: _itinerary cleanup: NO];
	CGPoint center			= ccp((self.contentSize.width - content.size.width)/2 - content.origin.x, (self.contentSize.height - content.size.height)/2 - content.origin.y/2);
	itinerary.position		= center;
	_starsLayer.position	= center;
	
	[self set_itinerary:	itinerary];
	[self addChild: itinerary z: 0];
}

- (void)newMapInfo:(uint)difficulty stageCompleted:(lvlDone_lvlTotal*)completed forstageName:(NSString*)stageName{
	static NSString* stringDifficulty[stageTotal] = {@"easy", @"normal", @"hard", @"expert"};
	[_stageInfo setString: [NSString stringWithFormat : @"%@\n%u/%u", stringDifficulty[difficulty], completed->done, completed->total]];
	[_mapTitle	setString: [stageName uppercaseString]];
}

#pragma mark setup
- (void)setUpStageInfo{

	self._stageInfo				= [[CCLabelBMFontMultiline labelWithString: nil
                                                          fntFile: @"FntFuturaWht_20.fnt"
                                                            width: 300
                                                        alignment: CenterAlignment] retain];
	_stageInfo.position		= ccp(390, 140);
	_stageInfo.anchorPoint	= ccp(0, 0.5f);
	
	self._mapTitle				= [[CCLabelBMFontMultiline labelWithString: nil
                                                            fntFile: @"FntProviWht_36.fnt"
                                                            width: 700
                                                            alignment: CenterAlignment] retain];
	_mapTitle.position		= ccp(420, 370);
	
	[self addChild:	_stageInfo];
	[self addChild:	_mapTitle];
}

#pragma mark alloc/dealloc
- (id)initMicroResume:(CCSpriteBatchNode*)stars{
	if ((self = [super initWithFile: mapResumBox])) {
		[self set_starsLayer: stars];
		[self addChild: stars z: 1];
		[self setUpStageInfo];
	}
	return self;
}

- (void)dealloc{
	[_mapTitle		release];
	[_stageInfo		release];
	[_itinerary		release];
	[_cantAccess	release];
	[_starsLayer	release];
	[super			dealloc];
}
@end
