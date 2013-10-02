//
//  GCTransition.m
//  picrossGame
//
//  Created by loïc Abadie on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GCTransition.h"
@interface GCTransition()
@property(nonatomic, assign)float	animeTime;
@property(nonatomic, assign)uint	addedTiles;
@property(nonatomic, assign)BOOL	isReverse;
@end

@implementation GCTransition
@synthesize animeTime,
			addedTiles,
			isReverse;

#define TOTALTILES 47
#pragma mark animation
- (void)animateSpire:(ccTime)time{
	animeTime += time;
	uint diff = animeTime / .08f;
	
	
	for(int i = addedTiles; i <= addedTiles + diff; i++){
		if(i <= TOTALTILES)
			[self getChildByTag: i].visible = !isReverse;
		else{
			[self unschedule: @selector(animateSpire:)];
			block_();
			break;
		}
	}
	addedTiles += diff;
}

#pragma mark setup
- (void)setUpSpire{
	static CGPoint pnt[TOTALTILES] = {	
		{520, 350},
		{433, 366},
		{452, 437},
		{585, 436},
		{600, 313},
		{485, 264},
		{355, 298},
		{356, 474},
		{480, 541},
		{635, 514},
		{727, 407},
		{702, 235},
		{568, 158},
		{395, 158},
		{280, 228},
		{224, 370},
		{260, 535},
		{364, 624},							
		{530, 652},
		{693, 623},
		{802, 528},
		{862, 405},
		{855, 238},
		{780, 130},
		{652, 66},
		{500, 30},
		{332, 60},
		{196, 128},
		{128, 270},
		{110, 440},
		{154, 614},
		{270, 726},
		{485, 774},
		{724, 757},
		{898, 686},
		{1002, 555},
		{1044, 322},
		{992, 102},
		{852, -65},
		{620, -110},
		{348, -110},
		{144, -60},
		{-4, 82},
		{-57, 310},
		{-50, 570},
		{46, 750},
        {1030, 790}};
	
	for (int i = 0; i < TOTALTILES; i++) {
		CCSprite* spt	= [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat:@"TR_%u.png", i]];
		spt.scale		= 3;
		spt.position	= pnt[i];
		spt.visible		= isReverse;
		[self addChild: spt z: 0 tag: (isReverse)? i : TOTALTILES - i];
	}
}

#pragma mark alloc/dealloc
- (id)initWithCallBack:(void(^)())block isReverse:(BOOL)isReverse_{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"Trans.plist"]; //<---
	
	if (self = [super initWithFile:@"Trans.png" capacity: 5]) {
		isReverse	= isReverse_;
		block_		= [block copy];
		[self setUpSpire];
		[self schedule:@selector(animateSpire:)];
	}
	return self;
}

+ (id)transitionWithCallBack:(void(^)())block isReverse:(BOOL)isReverse{
	return [[[self alloc] initWithCallBack: block isReverse: isReverse] autorelease];
}

- (void)dealloc{
	[block_ release];
	[super dealloc];
}
@end
