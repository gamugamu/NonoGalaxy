//
//  PCPercent.m
//  picrossGame
//
//  Created by loïc Abadie on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCPercent.h"
#import "CCLabelBMFontMultiline.h"

@interface PCPercent()
@property(nonatomic, retain)CCProgressTimer*		_radial;
@property(nonatomic, retain)CCLabelBMFontMultiline* _displayPercent;
@property(nonatomic, assign)uint					currentPercent;
@end

@implementation PCPercent
@synthesize currentPercent,
			_radial,
			_displayPercent;

- (void)displayPercent:(uint)percent{
	[_displayPercent setString: [NSString stringWithFormat:@"%u%%", percent]];
	currentPercent = percent;
	[self runAction: [CCSequence actions:
					  [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration:.3f scale: 1.2f]],
					  [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration:.3f scale: 1]], nil]];
}

#pragma mark setup

- (void)setUpPercentDisplay{
	[self set_displayPercent: [CCLabelBMFontMultiline labelWithString: @"0%" fntFile: @"percent.fnt" width: 170 alignment: RightAlignment]]; //<--
	_displayPercent.position	= ccp(0, 0);
	[self addChild: _displayPercent];
}

#pragma mark alloc/dealloc
- (id)initP{
	if(self = [super init]){
		[self setUpPercentDisplay];
	}
	return self;
}

- (void)dealloc{
	[_displayPercent	release];
	[_radial			release];
	[super				dealloc];
}
@end
