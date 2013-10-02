//
//  PCAnvil.m
//  picrossGame
//
//  Created by loïc Abadie on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCAnvil.h"
#import "CCLabelBMFontMultiline.h"

@interface PCAnvil()
@property(nonatomic, assign)color4Gl					aColor;
@property(nonatomic, assign)color4Gl					tmpColor;
@property(nonatomic, assign)uint						level;
@property(nonatomic, assign)uint						time;
@property(nonatomic, retain)CCLabelBMFontMultiline*		_stageLabel;
@property(nonatomic, retain)CCLabelBMFont*				_time;
@end

@implementation PCAnvil
@synthesize aColor,
			tmpColor,
			level,
			time,
			_stageLabel,
			_time;

#pragma mark public
- (void)setHilight:(BOOL)highlight{
	tmpColor = (highlight)? (color4Gl){250, 0, 0, 250} : aColor;
}

- (void)setStage:(uint)stage_ time:(uint)time_{
	[_stageLabel setString: [NSString stringWithFormat:@"STAGE %u", stage_]];
	level	= stage_;
	time	= time_;
}

- (void)copyDisplay:(PCAnvil*)anvil{
	[self setStage: anvil.level time: anvil.time];
	aColor		= anvil.aColor;
	tmpColor	= anvil.aColor;
	[self setHilight: YES];
}

#pragma mark override

#pragma mark private
- (void)draw{
	glColor4ub(tmpColor.red, tmpColor.green, tmpColor.blue, tmpColor.alpha);
	
	CGPoint vertices[] = { 
		ccp(0, 0), 
		ccp(0, 30), 
		ccp(102, 30), 
		ccp(102,  0)
	};
	ccFillPoly(vertices, 4, YES);
	
	glColor4ub(150, 150, 150, 255);
	CGPoint vertices2[] = { 
		ccp(0, 30), 
		ccp(10, 40), 
		ccp(113, 40), 
		ccp(103, 30)
	};
	
	ccFillPoly(vertices2, 4, YES);
}

#pragma mark setup
- (void)setUpStageLabel{
	[self set_stageLabel: [CCLabelBMFontMultiline labelWithString:@"" fntFile:@"FntHooge_25.fnt" width: 250 alignment: CenterAlignment]];
	_stageLabel.position = ccp(50, 12);
	[self addChild: _stageLabel];
}

- (void)setUpTime{
	[self set_time: [CCLabelBMFont labelWithString:@"00:00:00" fntFile:@"FntHooge_25.fnt"]];
	_time.position =  ccp(60, 52);
	[self addChild: _time];
}
#pragma mark alloc/dealloc
- (id)initWith4GColor:(color4Gl)color{
	if(self = [super init]){
		aColor		= color;
		tmpColor	= color;
		[self setUpStageLabel];
		[self setUpTime];
	}
	return self;
}

- (void)dealloc{
	[_time			release];
	[_stageLabel	release];
	[super			dealloc];
}
@end